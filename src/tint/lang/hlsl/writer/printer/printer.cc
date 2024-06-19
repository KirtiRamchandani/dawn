// Copyright 2024 The Dawn & Tint Authors
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include "src/tint/lang/hlsl/writer/printer/printer.h"

#include <cmath>
#include <cstddef>
#include <cstdint>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "src/tint/lang/core/access.h"
#include "src/tint/lang/core/address_space.h"
#include "src/tint/lang/core/builtin_value.h"
#include "src/tint/lang/core/constant/splat.h"
#include "src/tint/lang/core/constant/value.h"
#include "src/tint/lang/core/fluent_types.h"
#include "src/tint/lang/core/interpolation_sampling.h"
#include "src/tint/lang/core/interpolation_type.h"
#include "src/tint/lang/core/ir/access.h"
#include "src/tint/lang/core/ir/bitcast.h"
#include "src/tint/lang/core/ir/block.h"
#include "src/tint/lang/core/ir/break_if.h"
#include "src/tint/lang/core/ir/call.h"
#include "src/tint/lang/core/ir/constant.h"
#include "src/tint/lang/core/ir/construct.h"
#include "src/tint/lang/core/ir/continue.h"
#include "src/tint/lang/core/ir/core_binary.h"
#include "src/tint/lang/core/ir/core_builtin_call.h"
#include "src/tint/lang/core/ir/core_unary.h"
#include "src/tint/lang/core/ir/exit_if.h"
#include "src/tint/lang/core/ir/exit_loop.h"
#include "src/tint/lang/core/ir/if.h"
#include "src/tint/lang/core/ir/instruction_result.h"
#include "src/tint/lang/core/ir/let.h"
#include "src/tint/lang/core/ir/load.h"
#include "src/tint/lang/core/ir/load_vector_element.h"
#include "src/tint/lang/core/ir/loop.h"
#include "src/tint/lang/core/ir/module.h"
#include "src/tint/lang/core/ir/multi_in_block.h"
#include "src/tint/lang/core/ir/next_iteration.h"
#include "src/tint/lang/core/ir/return.h"
#include "src/tint/lang/core/ir/store.h"
#include "src/tint/lang/core/ir/swizzle.h"
#include "src/tint/lang/core/ir/unreachable.h"
#include "src/tint/lang/core/ir/user_call.h"
#include "src/tint/lang/core/ir/validator.h"
#include "src/tint/lang/core/ir/value.h"
#include "src/tint/lang/core/ir/var.h"
#include "src/tint/lang/core/texel_format.h"
#include "src/tint/lang/core/type/array.h"
#include "src/tint/lang/core/type/array_count.h"
#include "src/tint/lang/core/type/atomic.h"
#include "src/tint/lang/core/type/bool.h"
#include "src/tint/lang/core/type/depth_multisampled_texture.h"
#include "src/tint/lang/core/type/external_texture.h"
#include "src/tint/lang/core/type/f16.h"
#include "src/tint/lang/core/type/f32.h"
#include "src/tint/lang/core/type/i32.h"
#include "src/tint/lang/core/type/matrix.h"
#include "src/tint/lang/core/type/multisampled_texture.h"
#include "src/tint/lang/core/type/pointer.h"
#include "src/tint/lang/core/type/sampled_texture.h"
#include "src/tint/lang/core/type/sampler.h"
#include "src/tint/lang/core/type/storage_texture.h"
#include "src/tint/lang/core/type/struct.h"
#include "src/tint/lang/core/type/texture.h"
#include "src/tint/lang/core/type/texture_dimension.h"
#include "src/tint/lang/core/type/type.h"
#include "src/tint/lang/core/type/u32.h"
#include "src/tint/lang/core/type/vector.h"
#include "src/tint/lang/core/type/void.h"
#include "src/tint/utils/containers/hashmap.h"
#include "src/tint/utils/containers/map.h"
#include "src/tint/utils/generator/text_generator.h"
#include "src/tint/utils/ice/ice.h"
#include "src/tint/utils/macros/compiler.h"
#include "src/tint/utils/macros/scoped_assignment.h"
#include "src/tint/utils/rtti/switch.h"
#include "src/tint/utils/strconv/float_to_string.h"
#include "src/tint/utils/text/string.h"
#include "src/tint/utils/text/string_stream.h"

using namespace tint::core::fluent_types;  // NOLINT

namespace tint::hlsl::writer {
namespace {

/// PIMPL class for the HLSL generator
class Printer : public tint::TextGenerator {
  public:
    /// Constructor
    /// @param module the IR module to generate
    explicit Printer(core::ir::Module& module) : ir_(module) {}

    /// @returns the generated HLSL shader
    tint::Result<PrintResult> Generate() {
        auto valid = core::ir::ValidateAndDumpIfNeeded(ir_, "HLSL writer");
        if (valid != Success) {
            return std::move(valid.Failure());
        }

        // TOOD(dsinclair): EmitRootBlock

        // Emit functions.
        for (auto* func : ir_.DependencyOrderedFunctions()) {
            EmitFunction(func);
        }

        StringStream ss;
        ss << preamble_buffer_.String() << "\n" << main_buffer_.String();
        result_.hlsl = ss.str();

        return std::move(result_);
    }

  private:
    /// The result of printing the module.
    PrintResult result_;

    core::ir::Module& ir_;

    /// The buffer holding preamble text
    TextBuffer preamble_buffer_;

    /// A hashmap of value to name
    Hashmap<const core::ir::Value*, std::string, 32> names_;
    /// Map of builtin structure to unique generated name
    std::unordered_map<const core::type::Struct*, std::string> builtin_struct_names_;
    /// Set of structs which have been emitted already
    std::unordered_set<const core::type::Struct*> emitted_structs_;

    /// The current function being emitted
    const core::ir::Function* current_function_ = nullptr;
    /// The current block being emitted
    const core::ir::Block* current_block_ = nullptr;

    /// Block to emit for a continuing
    std::function<void()> emit_continuing_;

    void EmitFunction(const core::ir::Function* func) {
        TINT_SCOPED_ASSIGNMENT(current_function_, func);

        {
            if (func->Stage() == core::ir::Function::PipelineStage::kCompute) {
                auto wg_opt = func->WorkgroupSize();
                TINT_ASSERT(wg_opt.has_value());

                auto& wg = wg_opt.value();
                Line() << "[numthreads(" << wg[0] << ", " << wg[1] << ", " << wg[2] << ")]";
            }

            auto out = Line();
            auto func_name = NameOf(func);

            EmitType(out, func->ReturnType());
            out << " " << func_name << "(";

            bool is_ep = func->Stage() != core::ir::Function::PipelineStage::kUndefined;
            size_t i = 0;
            for (auto* param : func->Params()) {
                if (i > 0) {
                    out << ", ";
                }
                ++i;

                auto ptr = param->Type()->As<core::type::Pointer>();
                auto address_space = core::AddressSpace::kUndefined;
                auto access = core::Access::kUndefined;

                if (is_ep && !param->Type()->Is<core::type::Struct>()) {
                    // ICE likely indicates that the ShaderIO transform was not run, or a builtin
                    // parameter was added after it was run.
                    TINT_ICE() << "Unsupported non-struct entry point parameter";
                } else if (!is_ep && ptr) {
                    switch (ptr->AddressSpace()) {
                        case core::AddressSpace::kStorage:
                        case core::AddressSpace::kUniform: {
                            TINT_UNREACHABLE();
                        }
                        default:
                            // Transform regular pointer parameters in to `inout` parameters.
                            out << "inout ";
                    }
                }
                EmitTypeAndName(out, param->Type(), address_space, access, NameOf(param));
            }

            out << ") {";
        }
        {
            const ScopedIndent si(current_buffer_);
            EmitBlock(func->Block());
        }

        Line() << "}";
        Line();
    }

    void EmitBlock(const core::ir::Block* block) {
        TINT_SCOPED_ASSIGNMENT(current_block_, block);

        for (auto* inst : *block) {
            Switch(
                inst,                                                                    //
                [&](const core::ir::BreakIf* i) { EmitBreakIf(i); },                     //
                [&](const core::ir::Call* i) { EmitCallStmt(i); },                       //
                [&](const core::ir::Continue*) { EmitContinue(); },                      //
                [&](const core::ir::ExitLoop*) { EmitExitLoop(); },                      //
                [&](const core::ir::If* i) { EmitIf(i); },                               //
                [&](const core::ir::Let* i) { EmitLet(i); },                             //
                [&](const core::ir::Loop* l) { EmitLoop(l); },                           //
                [&](const core::ir::Return* i) { EmitReturn(i); },                       //
                [&](const core::ir::Store* i) { EmitStore(i); },                         //
                [&](const core::ir::Unreachable*) { EmitUnreachable(); },                //
                [&](const core::ir::Var* v) { EmitVar(v); },                             //
                                                                                         //
                [&](const core::ir::NextIteration*) { /* do nothing */ },                //
                [&](const core::ir::ExitIf*) { /* do nothing handled by transform */ },  //
                                                                                         //
                [&](const core::ir::Access*) { /* inlined */ },                          //
                [&](const core::ir::Bitcast*) { /* inlined */ },                         //
                [&](const core::ir::Construct*) { /* inlined */ },                       //
                [&](const core::ir::CoreBinary*) { /* inlined */ },                      //
                [&](const core::ir::CoreUnary*) { /* inlined */ },                       //
                [&](const core::ir::Load*) { /* inlined */ },                            //
                [&](const core::ir::LoadVectorElement*) { /* inlined */ },               //
                [&](const core::ir::Swizzle*) { /* inlined */ },                         //
                TINT_ICE_ON_NO_MATCH);
        }
    }

    /// Emit an if instruction
    /// @param if_ the if instruction
    void EmitIf(const core::ir::If* if_) {
        {
            auto out = Line();
            out << "if (";
            EmitValue(out, if_->Condition());
            out << ") {";
        }

        {
            const ScopedIndent si(current_buffer_);
            EmitBlock(if_->True());
        }

        if (if_->False() && !if_->False()->IsEmpty()) {
            Line() << "} else {";

            const ScopedIndent si(current_buffer_);
            EmitBlock(if_->False());
        }

        Line() << "}";
    }

    /// Emit an unreachable instruction
    void EmitUnreachable() { Line() << "/* unreachable */"; }

    void EmitContinue() {
        if (emit_continuing_) {
            emit_continuing_();
        }
        Line() << "continue;";
    }

    void EmitExitLoop() { Line() << "break;"; }

    void EmitBreakIf(const core::ir::BreakIf* b) {
        auto out = Line();
        out << "if (";
        EmitValue(out, b->Condition());
        out << ") { break; }";
    }

    void EmitLoop(const core::ir::Loop* l) {
        // Note, we can't just emit the continuing inside a conditional at the top of the loop
        // because any variable declared in the block must be visible to the continuing.
        //
        // loop {
        //   var a = 3;
        //   continue {
        //     let y = a;
        //   }
        // }

        auto emit_continuing = [&] {
            Line() << "{";
            {
                const ScopedIndent si(current_buffer_);
                EmitBlock(l->Continuing());
            }
            Line() << "}";
        };
        TINT_SCOPED_ASSIGNMENT(emit_continuing_, emit_continuing);

        Line() << "{";
        {
            const ScopedIndent init(current_buffer_);
            EmitBlock(l->Initializer());

            Line() << "while(true) {";
            {
                const ScopedIndent si(current_buffer_);
                EmitBlock(l->Body());
            }
            Line() << "}";
        }
        Line() << "}";
    }

    void EmitCallStmt(const core::ir::Call* c) {
        if (!c->Result(0)->IsUsed()) {
            auto out = Line();
            EmitValue(out, c->Result(0));
            out << ";";
        }
    }

    void EmitVar(const core::ir::Var* var) {
        auto* ptr = var->Result(0)->Type()->As<core::type::Pointer>();
        TINT_ASSERT(ptr);

        auto space = ptr->AddressSpace();

        auto out = Line();
        EmitTypeAndName(out, var->Result(0)->Type(), space, ptr->Access(), NameOf(var->Result(0)));
        out << " = ";

        if (var->Initializer()) {
            EmitValue(out, var->Initializer());
        } else if (space == core::AddressSpace::kPrivate ||
                   space == core::AddressSpace::kFunction ||
                   space == core::AddressSpace::kUndefined) {
            EmitZeroValue(out, ptr->UnwrapPtr());
        }
        out << ";";
    }

    /// Emits the zero value for the given type
    /// @param out the stream to emit too
    /// @param ty the type
    void EmitZeroValue(StringStream& out, const core::type::Type* ty) {
        EmitConstant(out, ir_.constant_values.Zero(ty));
    }

    void EmitLet(const core::ir::Let* l) {
        auto out = Line();

        // TODO(dsinclair): Investigate using `const` here as well, the AST printer doesn't emit
        //                  const with a let, but we should be able to.
        EmitTypeAndName(out, l->Result(0)->Type(), core::AddressSpace::kUndefined,
                        core::Access::kUndefined, NameOf(l->Result(0)));
        out << " = ";
        EmitValue(out, l->Value());
        out << ";";
    }

    void EmitReturn(const core::ir::Return* r) {
        // If this return has no arguments and the current block is for the function which is
        // being returned, skip the return.
        if (current_block_ == current_function_->Block() && r->Args().IsEmpty()) {
            return;
        }

        auto out = Line();
        out << "return";
        if (!r->Args().IsEmpty()) {
            out << " ";
            EmitValue(out, r->Args().Front());
        }
        out << ";";
    }

    void EmitValue(StringStream& out, const core::ir::Value* v) {
        Switch(
            v,                                                           //
            [&](const core::ir::Constant* c) { EmitConstant(out, c); },  //
            [&](const core::ir::InstructionResult* r) {
                Switch(
                    r->Instruction(),                                                          //
                    [&](const core::ir::Access* a) { EmitAccess(out, a); },                    //
                    [&](const core::ir::CoreBinary* b) { EmitBinary(out, b); },                //
                    [&](const core::ir::CoreBuiltinCall* c) { EmitCoreBuiltinCall(out, c); },  //
                    [&](const core::ir::CoreUnary* u) { EmitUnary(out, u); },                  //
                    [&](const core::ir::Let* l) { out << NameOf(l->Result(0)); },              //
                    [&](const core::ir::Load* l) { EmitLoad(out, l); },                        //
                    [&](const core::ir::UserCall* c) { EmitUserCall(out, c); },                //
                    [&](const core::ir::Swizzle* s) { EmitSwizzle(out, s); },                  //
                    [&](const core::ir::Var* var) { out << NameOf(var->Result(0)); },          //
                    TINT_ICE_ON_NO_MATCH);
            },
            [&](const core::ir::FunctionParam* p) { out << NameOf(p); },  //
            TINT_ICE_ON_NO_MATCH);
    }

    void EmitUnary(StringStream& out, const core::ir::CoreUnary* u) {
        switch (u->Op()) {
            case core::UnaryOp::kNegation:
                out << "-";
                break;
            case core::UnaryOp::kComplement:
                out << "~";
                break;
            case core::UnaryOp::kNot:
                out << "!";
                break;
            default:
                TINT_UNIMPLEMENTED() << u->Op();
        }
        out << "(";
        EmitValue(out, u->Val());
        out << ")";
    }

    void EmitSwizzle(StringStream& out, const core::ir::Swizzle* swizzle) {
        EmitValue(out, swizzle->Object());
        out << ".";
        for (const auto i : swizzle->Indices()) {
            switch (i) {
                case 0:
                    out << "x";
                    break;
                case 1:
                    out << "y";
                    break;
                case 2:
                    out << "z";
                    break;
                case 3:
                    out << "w";
                    break;
                default:
                    TINT_UNREACHABLE();
            }
        }
    }

    /// Emit an access instruction
    void EmitAccess(StringStream& out, const core::ir::Access* a) {
        EmitValue(out, a->Object());

        auto* current_type = a->Object()->Type();
        for (auto* index : a->Indices()) {
            TINT_ASSERT(current_type);

            current_type = current_type->UnwrapPtr();
            Switch(
                current_type,  //
                [&](const core::type::Struct* s) {
                    auto* c = index->As<core::ir::Constant>();
                    auto* member = s->Members()[c->Value()->ValueAs<uint32_t>()];
                    out << "." << member->Name().Name();
                    current_type = member->Type();
                },
                [&](Default) {
                    out << "[";
                    EmitValue(out, index);
                    out << "]";
                    current_type = current_type->Element(0);
                });
        }
    }

    void EmitCoreBuiltinCall(StringStream& out, const core::ir::CoreBuiltinCall* c) {
        EmitCoreBuiltinName(out, c->Func());

        ScopedParen sp(out);
        size_t i = 0;
        for (const auto* arg : c->Args()) {
            if (i > 0) {
                out << ", ";
            }
            ++i;

            EmitValue(out, arg);
        }
    }

    void EmitCoreBuiltinName(StringStream& out, core::BuiltinFn func) {
        switch (func) {
            case core::BuiltinFn::kAbs:
            case core::BuiltinFn::kAcos:
            case core::BuiltinFn::kAll:
            case core::BuiltinFn::kAny:
            case core::BuiltinFn::kAsin:
            case core::BuiltinFn::kAtan:
            case core::BuiltinFn::kAtan2:
            case core::BuiltinFn::kCeil:
            case core::BuiltinFn::kClamp:
            case core::BuiltinFn::kCos:
            case core::BuiltinFn::kCosh:
            case core::BuiltinFn::kCross:
            case core::BuiltinFn::kDeterminant:
            case core::BuiltinFn::kDistance:
            case core::BuiltinFn::kDot:
            case core::BuiltinFn::kExp:
            case core::BuiltinFn::kExp2:
            case core::BuiltinFn::kFloor:
            case core::BuiltinFn::kFrexp:
            case core::BuiltinFn::kLdexp:
            case core::BuiltinFn::kLength:
            case core::BuiltinFn::kLog:
            case core::BuiltinFn::kLog2:
            case core::BuiltinFn::kMax:
            case core::BuiltinFn::kMin:
            case core::BuiltinFn::kModf:
            case core::BuiltinFn::kNormalize:
            case core::BuiltinFn::kPow:
            case core::BuiltinFn::kReflect:
            case core::BuiltinFn::kRefract:
            case core::BuiltinFn::kRound:
            case core::BuiltinFn::kSaturate:
            case core::BuiltinFn::kSin:
            case core::BuiltinFn::kSinh:
            case core::BuiltinFn::kSqrt:
            case core::BuiltinFn::kStep:
            case core::BuiltinFn::kTan:
            case core::BuiltinFn::kTanh:
            case core::BuiltinFn::kTranspose:
                out << func;
                break;
            case core::BuiltinFn::kCountOneBits:  // uint
                out << "countbits";
                break;
            case core::BuiltinFn::kDpdx:
                out << "ddx";
                break;
            case core::BuiltinFn::kDpdxCoarse:
                out << "ddx_coarse";
                break;
            case core::BuiltinFn::kDpdxFine:
                out << "ddx_fine";
                break;
            case core::BuiltinFn::kDpdy:
                out << "ddy";
                break;
            case core::BuiltinFn::kDpdyCoarse:
                out << "ddy_coarse";
                break;
            case core::BuiltinFn::kDpdyFine:
                out << "ddy_fine";
                break;
            case core::BuiltinFn::kFaceForward:
                out << "faceforward";
                break;
            case core::BuiltinFn::kFract:
                out << "frac";
                break;
            case core::BuiltinFn::kFma:
                out << "mad";
                break;
            case core::BuiltinFn::kFwidth:
            case core::BuiltinFn::kFwidthCoarse:
            case core::BuiltinFn::kFwidthFine:
                out << "fwidth";
                break;
            case core::BuiltinFn::kInverseSqrt:
                out << "rsqrt";
                break;
            case core::BuiltinFn::kMix:
                out << "lerp";
                break;
            case core::BuiltinFn::kReverseBits:  // uint
                out << "reversebits";
                break;
            case core::BuiltinFn::kSubgroupBroadcast:
                out << "WaveReadLaneAt";
                break;

            default:
                TINT_UNREACHABLE() << "unhandled: " << func;
        }
    }

    /// Emit Load
    /// @param out the output stream to write to
    /// @param load the load
    void EmitLoad(StringStream& out, const core::ir::Load* load) { EmitValue(out, load->From()); }

    /// Emit a store
    void EmitStore(const core::ir::Store* s) {
        auto out = Line();

        EmitValue(out, s->To());
        out << " = ";
        EmitValue(out, s->From());
        out << ";";
    }

    /// Emit a binary instruction
    /// @param b the binary instruction
    void EmitBinary(StringStream& out, const core::ir::CoreBinary* b) {
        // TODO(dsinclair): Short circuring transform
        // TODO(dsinclair): Transform matrix multiplication into a `mul` instruction

        auto kind = [&] {
            switch (b->Op()) {
                case core::BinaryOp::kAdd:
                    return "+";
                case core::BinaryOp::kSubtract:
                    return "-";
                case core::BinaryOp::kMultiply:
                    return "*";
                case core::BinaryOp::kDivide:
                    return "/";
                case core::BinaryOp::kModulo:
                    return "%";
                case core::BinaryOp::kAnd:
                    return "&";
                case core::BinaryOp::kOr:
                    return "|";
                case core::BinaryOp::kXor:
                    return "^";
                case core::BinaryOp::kEqual:
                    return "==";
                case core::BinaryOp::kNotEqual:
                    return "!=";
                case core::BinaryOp::kLessThan:
                    return "<";
                case core::BinaryOp::kGreaterThan:
                    return ">";
                case core::BinaryOp::kLessThanEqual:
                    return "<=";
                case core::BinaryOp::kGreaterThanEqual:
                    return ">=";
                case core::BinaryOp::kShiftLeft:
                    return "<<";
                case core::BinaryOp::kShiftRight:
                    return ">>";
                case core::BinaryOp::kLogicalAnd:
                case core::BinaryOp::kLogicalOr:
                    // These should have been replaced by if statments as HLSL is not
                    // short-circuting.
                    TINT_UNREACHABLE() << "logical and/or should not be present";
            }
            return "<error>";
        };

        ScopedParen sp(out);
        EmitValue(out, b->LHS());
        out << " " << kind() << " ";
        EmitValue(out, b->RHS());
    }

    /// Emits a user call instruction
    void EmitUserCall(StringStream& out, const core::ir::UserCall* c) {
        out << NameOf(c->Target()) << "(";
        size_t i = 0;
        for (const auto* arg : c->Args()) {
            if (i > 0) {
                out << ", ";
            }
            ++i;

            EmitValue(out, arg);
        }
        out << ")";
    }

    void EmitConstant(StringStream& out, const core::ir::Constant* c) {
        EmitConstant(out, c->Value());
    }

    void EmitConstant(StringStream& out, const core::constant::Value* c) {
        Switch(
            c->Type(),  //
            [&](const core::type::Bool*) { out << (c->ValueAs<AInt>() ? "true" : "false"); },
            [&](const core::type::F16*) { EmitConstantF16(out, c); },
            [&](const core::type::F32*) { PrintF32(out, c->ValueAs<f32>()); },
            [&](const core::type::I32*) { out << c->ValueAs<i32>(); },
            [&](const core::type::U32*) { out << c->ValueAs<AInt>() << "u"; },
            [&](const core::type::Array* a) { EmitConstantArray(out, c, a); },
            [&](const core::type::Vector* v) { EmitConstantVector(out, c, v); },
            [&](const core::type::Matrix* m) { EmitConstantMatrix(out, c, m); },
            [&](const core::type::Struct* s) { EmitConstantStruct(out, c, s); },  //
            TINT_ICE_ON_NO_MATCH);
    }

    void EmitConstantF16(StringStream& out, const core::constant::Value* c) {
        // Emit a f16 scalar with explicit float16_t type declaration.
        out << "float16_t";
        const ScopedParen sp(out);
        PrintF16(out, c->ValueAs<f16>());
    }

    void EmitConstantArray(StringStream& out,
                           const core::constant::Value* c,
                           const core::type::Array* a) {
        if (c->AllZero()) {
            out << "(";
            EmitType(out, a);
            out << ")0";
            return;
        }

        out << "{";

        auto count = a->ConstantCount();
        TINT_ASSERT(count.has_value() && count.value() > 0);

        for (size_t i = 0; i < count; i++) {
            if (i > 0) {
                out << ", ";
            }
            EmitConstant(out, c->Index(i));
        }

        out << "}";
    }

    void EmitConstantVector(StringStream& out,
                            const core::constant::Value* c,
                            const core::type::Vector* v) {
        if (auto* splat = c->As<core::constant::Splat>()) {
            {
                const ScopedParen sp(out);
                EmitConstant(out, splat->el);
            }
            out << ".";
            for (size_t i = 0; i < v->Width(); i++) {
                out << "x";
            }
            return;
        }

        EmitType(out, v);

        const ScopedParen sp(out);
        for (size_t i = 0; i < v->Width(); i++) {
            if (i > 0) {
                out << ", ";
            }
            EmitConstant(out, c->Index(i));
        }
    }

    void EmitConstantMatrix(StringStream& out,
                            const core::constant::Value* c,
                            const core::type::Matrix* m) {
        EmitType(out, m);

        const ScopedParen sp(out);
        for (size_t i = 0; i < m->columns(); i++) {
            if (i > 0) {
                out << ", ";
            }
            EmitConstant(out, c->Index(i));
        }
    }

    void EmitConstantStruct(StringStream& out,
                            const core::constant::Value* c,
                            const core::type::Struct* s) {
        EmitStructType(s);

        if (c->AllZero()) {
            out << "(" << StructName(s) << ")0";
            return;
        }
    }

    void EmitTypeAndName(StringStream& out,
                         const core::type::Type* type,
                         core::AddressSpace address_space,
                         core::Access access,
                         const std::string& name) {
        bool name_printed = false;
        EmitType(out, type, address_space, access, name, &name_printed);

        if (!name.empty() && !name_printed) {
            out << " " << name;
        }
    }

    void EmitType(StringStream& out,
                  const core::type::Type* ty,
                  core::AddressSpace address_space = core::AddressSpace::kUndefined,
                  core::Access access = core::Access::kUndefined,
                  const std::string& name = "",
                  bool* name_printed = nullptr) {
        if (name_printed) {
            *name_printed = false;
        }

        switch (address_space) {
            case core::AddressSpace::kStorage:
                if (access != core::Access::kRead) {
                    out << "RW";
                }
                out << "ByteAddressBuffer";
                return;
            case core::AddressSpace::kUniform: {
                auto array_length = (ty->Size() + 15) / 16;
                out << "uint4 " << name << "[" << array_length << "]";
                if (name_printed) {
                    *name_printed = true;
                }
                return;
            }
            default:
                break;
        }

        Switch(
            ty,                                                   //
            [&](const core::type::Bool*) { out << "bool"; },      //
            [&](const core::type::F16*) { out << "float16_t"; },  //
            [&](const core::type::F32*) { out << "float"; },      //
            [&](const core::type::I32*) { out << "int"; },        //
            [&](const core::type::U32*) { out << "uint"; },       //
            [&](const core::type::Void*) { out << "void"; },      //

            [&](const core::type::Atomic* atomic) {
                EmitType(out, atomic->Type(), address_space, access, name);
            },
            [&](const core::type::Array* ary) {
                EmitArrayType(out, ary, address_space, access, name, name_printed);
            },
            [&](const core::type::Vector* vec) { EmitVectorType(out, vec, address_space, access); },
            [&](const core::type::Matrix* mat) { EmitMatrixType(out, mat, address_space, access); },
            [&](const core::type::Struct* str) {
                out << StructName(str);
                EmitStructType(str);
            },

            [&](const core::type::Pointer* p) {
                EmitType(out, p->StoreType(), p->AddressSpace(), p->Access(), name, name_printed);
            },
            [&](const core::type::Sampler* sampler) { EmitSamplerType(out, sampler); },
            [&](const core::type::Texture* tex) { EmitTextureType(out, tex); },
            TINT_ICE_ON_NO_MATCH);
    }

    void EmitArrayType(StringStream& out,
                       const core::type::Array* ary,
                       core::AddressSpace address_space,
                       core::Access access,
                       const std::string& name,
                       bool* name_printed) {
        const core::type::Type* base_type = ary;
        std::vector<uint32_t> sizes;
        while (auto* arr = base_type->As<core::type::Array>()) {
            if (TINT_UNLIKELY(arr->Count()->Is<core::type::RuntimeArrayCount>())) {
                TINT_ICE() << "runtime arrays may only exist in storage buffers, which "
                              "should have "
                              "been transformed into a ByteAddressBuffer";
            }
            const auto count = arr->ConstantCount();
            TINT_ASSERT(count.has_value() && count.value() > 0);

            sizes.push_back(count.value());
            base_type = arr->ElemType();
        }
        EmitType(out, base_type, address_space, access);

        if (!name.empty()) {
            out << " " << name;
            if (name_printed) {
                *name_printed = true;
            }
        }

        for (const uint32_t size : sizes) {
            out << "[" << size << "]";
        }
    }

    void EmitVectorType(StringStream& out,
                        const core::type::Vector* vec,
                        core::AddressSpace address_space,
                        core::Access access) {
        auto width = vec->Width();
        if (vec->type()->Is<core::type::F32>()) {
            out << "float" << width;
        } else if (vec->type()->Is<core::type::I32>()) {
            out << "int" << width;
        } else if (vec->type()->Is<core::type::U32>()) {
            out << "uint" << width;
        } else if (vec->type()->Is<core::type::Bool>()) {
            out << "bool" << width;
        } else {
            // For example, use "vector<float16_t, N>" for f16 vector.
            out << "vector<";
            EmitType(out, vec->type(), address_space, access);
            out << ", " << width << ">";
        }
    }

    void EmitMatrixType(StringStream& out,
                        const core::type::Matrix* mat,
                        core::AddressSpace address_space,
                        core::Access access) {
        if (mat->type()->Is<core::type::F16>()) {
            // Use matrix<type, N, M> for f16 matrix
            out << "matrix<";
            EmitType(out, mat->type(), address_space, access);
            out << ", " << mat->columns() << ", " << mat->rows() << ">";
            return;
        }

        EmitType(out, mat->type(), address_space, access);

        // Note: HLSL's matrices are declared as <type>NxM, where N is the
        // number of rows and M is the number of columns. Despite HLSL's
        // matrices being column-major by default, the index operator and
        // initializers actually operate on row-vectors, where as WGSL operates
        // on column vectors. To simplify everything we use the transpose of the
        // matrices. See:
        // https://docs.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-per-component-math#matrix-ordering
        out << mat->columns() << "x" << mat->rows();
    }

    void EmitTextureType(StringStream& out, const core::type::Texture* tex) {
        if (TINT_UNLIKELY(tex->Is<core::type::ExternalTexture>())) {
            TINT_ICE() << "Multiplanar external texture transform was not run.";
        }

        auto* storage = tex->As<core::type::StorageTexture>();
        auto* ms = tex->As<core::type::MultisampledTexture>();
        auto* depth_ms = tex->As<core::type::DepthMultisampledTexture>();
        auto* sampled = tex->As<core::type::SampledTexture>();

        if (storage && storage->access() != core::Access::kRead) {
            out << "RW";
        }
        out << "Texture";

        switch (tex->dim()) {
            case core::type::TextureDimension::k1d:
                out << "1D";
                break;
            case core::type::TextureDimension::k2d:
                out << ((ms || depth_ms) ? "2DMS" : "2D");
                break;
            case core::type::TextureDimension::k2dArray:
                out << ((ms || depth_ms) ? "2DMSArray" : "2DArray");
                break;
            case core::type::TextureDimension::k3d:
                out << "3D";
                break;
            case core::type::TextureDimension::kCube:
                out << "Cube";
                break;
            case core::type::TextureDimension::kCubeArray:
                out << "CubeArray";
                break;
            default:
                TINT_UNREACHABLE() << "unexpected TextureDimension " << tex->dim();
        }

        if (storage) {
            auto* component = ImageFormatToRWtextureType(storage->texel_format());
            if (TINT_UNLIKELY(!component)) {
                TINT_ICE() << "Unsupported StorageTexture TexelFormat: "
                           << static_cast<int>(storage->texel_format());
            }
            out << "<" << component << ">";
        } else if (depth_ms) {
            out << "<float4>";
        } else if (sampled || ms) {
            auto* subtype = sampled ? sampled->type() : ms->type();
            out << "<";
            if (subtype->Is<core::type::F32>()) {
                out << "float4";
            } else if (subtype->Is<core::type::I32>()) {
                out << "int4";
            } else if (TINT_LIKELY(subtype->Is<core::type::U32>())) {
                out << "uint4";
            } else {
                TINT_ICE() << "Unsupported multisampled texture type";
            }
            out << ">";
        }
    }

    void EmitSamplerType(StringStream& out, const core::type::Sampler* sampler) {
        out << "Sampler";
        if (sampler->IsComparison()) {
            out << "Comparison";
        }
        out << "State";
    }

    void EmitStructType(const core::type::Struct* str) {
        auto it = emitted_structs_.emplace(str);
        if (!it.second) {
            return;
        }

        TextBuffer str_buf;
        Line(&str_buf) << "struct " << StructName(str) << " {";
        {
            const ScopedIndent si(&str_buf);
            for (auto* mem : str->Members()) {
                auto mem_name = mem->Name().Name();
                auto* ty = mem->Type();
                auto out = Line(&str_buf);

                auto& attributes = mem->Attributes();

                std::string pre;
                std::string post;
                if (auto location = attributes.location) {
                    auto& pipeline_stage_uses = str->PipelineStageUses();
                    if (TINT_UNLIKELY(pipeline_stage_uses.Count() != 1)) {
                        TINT_ICE() << "invalid entry point IO struct uses";
                    }
                    if (pipeline_stage_uses.Contains(
                            core::type::PipelineStageUsage::kVertexInput)) {
                        post += " : TEXCOORD" + std::to_string(location.value());
                    } else if (pipeline_stage_uses.Contains(
                                   core::type::PipelineStageUsage::kVertexOutput)) {
                        post += " : TEXCOORD" + std::to_string(location.value());
                    } else if (pipeline_stage_uses.Contains(
                                   core::type::PipelineStageUsage::kFragmentInput)) {
                        post += " : TEXCOORD" + std::to_string(location.value());
                    } else if (TINT_LIKELY(pipeline_stage_uses.Contains(
                                   core::type::PipelineStageUsage::kFragmentOutput))) {
                        if (auto blend_src = attributes.blend_src) {
                            post += " : SV_Target" +
                                    std::to_string(location.value() + blend_src.value());
                        } else {
                            post += " : SV_Target" + std::to_string(location.value());
                        }

                    } else {
                        TINT_ICE() << "invalid use of location attribute";
                    }
                }
                if (auto builtin = attributes.builtin) {
                    auto name = builtin_to_attribute(builtin.value());
                    TINT_ASSERT(!name.empty());

                    post += " : " + name;
                }
                if (auto interpolation = attributes.interpolation) {
                    auto mod =
                        interpolation_to_modifiers(interpolation->type, interpolation->sampling);
                    TINT_ASSERT(!mod.empty());

                    pre += mod;
                }
                if (attributes.invariant) {
                    // Note: `precise` is not exactly the same as `invariant`, but is
                    // stricter and therefore provides the necessary guarantees.
                    // See discussion here: https://github.com/gpuweb/gpuweb/issues/893
                    pre += "precise ";
                }

                out << pre;
                EmitTypeAndName(out, ty, core::AddressSpace::kUndefined, core::Access::kReadWrite,
                                mem_name);
                out << post << ";";
            }
        }

        Line(&str_buf) << "};";
        Line(&str_buf) << "";

        preamble_buffer_.Append(str_buf);
    }

    std::string builtin_to_attribute(core::BuiltinValue builtin) const {
        switch (builtin) {
            case core::BuiltinValue::kPosition:
                return "SV_Position";
            case core::BuiltinValue::kVertexIndex:
                return "SV_VertexID";
            case core::BuiltinValue::kInstanceIndex:
                return "SV_InstanceID";
            case core::BuiltinValue::kFrontFacing:
                return "SV_IsFrontFace";
            case core::BuiltinValue::kFragDepth:
                return "SV_Depth";
            case core::BuiltinValue::kLocalInvocationId:
                return "SV_GroupThreadID";
            case core::BuiltinValue::kLocalInvocationIndex:
                return "SV_GroupIndex";
            case core::BuiltinValue::kGlobalInvocationId:
                return "SV_DispatchThreadID";
            case core::BuiltinValue::kWorkgroupId:
                return "SV_GroupID";
            case core::BuiltinValue::kSampleIndex:
                return "SV_SampleIndex";
            case core::BuiltinValue::kSampleMask:
                return "SV_Coverage";
            default:
                break;
        }
        return "";
    }

    std::string interpolation_to_modifiers(core::InterpolationType type,
                                           core::InterpolationSampling sampling) const {
        std::string modifiers;
        switch (type) {
            case core::InterpolationType::kPerspective:
                modifiers += "linear ";
                break;
            case core::InterpolationType::kLinear:
                modifiers += "noperspective ";
                break;
            case core::InterpolationType::kFlat:
                modifiers += "nointerpolation ";
                break;
            case core::InterpolationType::kUndefined:
                break;
        }
        switch (sampling) {
            case core::InterpolationSampling::kCentroid:
                modifiers += "centroid ";
                break;
            case core::InterpolationSampling::kSample:
                modifiers += "sample ";
                break;
            case core::InterpolationSampling::kCenter:
            case core::InterpolationSampling::kUndefined:
                break;
        }
        return modifiers;
    }

    /// @returns the name of the given value, creating a new unique name if the value is unnamed in
    /// the module.
    std::string NameOf(const core::ir::Value* value) {
        return names_.GetOrAdd(value, [&] {
            auto sym = ir_.NameOf(value);
            return sym.IsValid() ? sym.Name() : UniqueIdentifier("v");
        });
    }

    /// @return a new, unique identifier with the given prefix.
    /// @param prefix optional prefix to apply to the generated identifier. If empty
    /// "tint_symbol" will be used.
    std::string UniqueIdentifier(const std::string& prefix /* = "" */) {
        return ir_.symbols.New(prefix).Name();
    }

    std::string StructName(const core::type::Struct* s) {
        auto name = s->Name().Name();
        if (HasPrefix(name, "__")) {
            name = tint::GetOrAdd(builtin_struct_names_, s,
                                  [&] { return UniqueIdentifier(name.substr(2)); });
        }
        return name;
    }

    void PrintF32(StringStream& out, float value) {
        if (std::isinf(value)) {
            out << "0.0f " << (value >= 0 ? "/* inf */" : "/* -inf */");
        } else if (std::isnan(value)) {
            out << "0.0f /* nan */";
        } else {
            out << tint::strconv::FloatToString(value) << "f";
        }
    }

    void PrintF16(StringStream& out, float value) {
        if (std::isinf(value)) {
            out << "0.0h " << (value >= 0 ? "/* inf */" : "/* -inf */");
        } else if (std::isnan(value)) {
            out << "0.0h /* nan */";
        } else {
            out << tint::strconv::FloatToString(value) << "h";
        }
    }

    const char* ImageFormatToRWtextureType(core::TexelFormat image_format) {
        switch (image_format) {
            case core::TexelFormat::kR8Unorm:
            case core::TexelFormat::kBgra8Unorm:
            case core::TexelFormat::kRgba8Unorm:
            case core::TexelFormat::kRgba8Snorm:
            case core::TexelFormat::kRgba16Float:
            case core::TexelFormat::kR32Float:
            case core::TexelFormat::kRg32Float:
            case core::TexelFormat::kRgba32Float:
                return "float4";
            case core::TexelFormat::kRgba8Uint:
            case core::TexelFormat::kRgba16Uint:
            case core::TexelFormat::kR32Uint:
            case core::TexelFormat::kRg32Uint:
            case core::TexelFormat::kRgba32Uint:
                return "uint4";
            case core::TexelFormat::kRgba8Sint:
            case core::TexelFormat::kRgba16Sint:
            case core::TexelFormat::kR32Sint:
            case core::TexelFormat::kRg32Sint:
            case core::TexelFormat::kRgba32Sint:
                return "int4";
            default:
                return nullptr;
        }
    }
};

}  // namespace

Result<PrintResult> Print(core::ir::Module& module) {
    return Printer{module}.Generate();
}

PrintResult::PrintResult() = default;

PrintResult::~PrintResult() = default;

PrintResult::PrintResult(const PrintResult&) = default;

PrintResult& PrintResult::operator=(const PrintResult&) = default;

}  // namespace tint::hlsl::writer
