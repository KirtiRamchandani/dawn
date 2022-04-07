// Copyright 2020 The Tint Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef SRC_TINT_READER_SPIRV_CONSTRUCT_H_
#define SRC_TINT_READER_SPIRV_CONSTRUCT_H_

#include <memory>
#include <sstream>
#include <string>
#include <vector>

namespace tint::reader::spirv {

/// A structured control flow construct, consisting of a set of basic blocks.
/// A construct is a span of blocks in the computed block order,
/// and will appear contiguously in the WGSL source.
///
/// SPIR-V (2.11 Structured Control Flow) defines:
///   - loop construct
///   - continue construct
///   - selection construct
/// We also define a "function construct" consisting of all the basic blocks in
/// the function.
///
/// The first block in a construct (by computed block order) is called a
/// "header". For the constructs defined by SPIR-V, the header block is the
/// basic block containing the merge instruction.  The header for the function
/// construct is the entry block of the function.
///
/// Given two constructs A and B, we say "A encloses B" if B is a subset of A,
/// i.e. if every basic block in B is also in A.  Note that a construct encloses
/// itself.
///
/// In a valid SPIR-V module, constructs will nest, meaning given
/// constructs A and B, either A encloses B, or B encloses A, or
/// or they are disjoint (have no basic blocks in commont).
///
/// A loop in a high level language translates into either:
//
///  - a single-block loop, where the loop header branches back to itself.
///     In this case this single-block loop consists only of the *continue
///     construct*.  There is no "loop construct" for this case.
//
///  - a multi-block loop, where the loop back-edge is different from the loop
///     header.
///     This case has both a non-empty loop construct containing at least the
///     loop header, and a non-empty continue construct, containing at least the
///     back-edge block.
///
/// We care about two kinds of selection constructs:
///
///  - if-selection: where the header block ends in OpBranchConditional
///
///  - switch-selection: where the header block ends in OpSwitch
///
struct Construct {
  /// Enumeration for the kinds of structured constructs.
  enum Kind {
    /// The whole function.
    kFunction,
    /// A SPIR-V selection construct, header basic block ending in
    /// OpBrancConditional.
    kIfSelection,
    /// A SPIR-V selection construct, header basic block ending in OpSwitch.
    kSwitchSelection,
    /// A SPIR-V loop construct.
    kLoop,
    /// A SPIR-V continue construct.
    kContinue,
  };

  /// Constructor
  /// @param the_parent parent construct
  /// @param the_depth construct nesting depth
  /// @param the_kind construct kind
  /// @param the_begin_id block id of the first block in the construct
  /// @param the_end_id block id of the first block after the construct, or 0
  /// @param the_begin_pos block order position of the_begin_id
  /// @param the_end_pos block order position of the_end_id or a too-large value
  /// @param the_scope_end_pos block position of the first block past the end of
  /// the WGSL scope
  Construct(const Construct* the_parent,
            int the_depth,
            Kind the_kind,
            uint32_t the_begin_id,
            uint32_t the_end_id,
            uint32_t the_begin_pos,
            uint32_t the_end_pos,
            uint32_t the_scope_end_pos);

  /// @param pos a block position
  /// @returns true if the given block position is inside this construct.
  bool ContainsPos(uint32_t pos) const {
    return begin_pos <= pos && pos < end_pos;
  }
  /// Returns true if the given block position is inside the WGSL scope
  /// corresponding to this construct. A loop construct's WGSL scope encloses
  /// the associated continue construct. Otherwise the WGSL scope extent is the
  /// same as the block extent.
  /// @param pos a block position
  /// @returns true if the given block position is inside the WGSL scope.
  bool ScopeContainsPos(uint32_t pos) const {
    return begin_pos <= pos && pos < scope_end_pos;
  }

  /// The nearest enclosing construct other than itself, or nullptr if
  /// this construct represents the entire function.
  const Construct* const parent = nullptr;
  /// The nearest enclosing loop construct, if one exists.  Points to `this`
  /// when this is a loop construct.
  const Construct* const enclosing_loop = nullptr;
  /// The nearest enclosing continue construct, if one exists.  Points to
  /// `this` when this is a contnue construct.
  const Construct* const enclosing_continue = nullptr;
  /// The nearest enclosing loop construct or continue construct or
  /// switch-selection construct, if one exists. The signficance is
  /// that a high level language "break" will branch to the merge block
  /// of such an enclosing construct. Points to `this` when this is
  /// a loop construct, a continue construct, or a switch-selection construct.
  const Construct* const enclosing_loop_or_continue_or_switch = nullptr;

  /// Control flow nesting depth. The entry block is at nesting depth 0.
  const int depth = 0;
  /// The construct kind
  const Kind kind = kFunction;
  /// The id of the first block in this structure.
  const uint32_t begin_id = 0;
  /// 0 for kFunction, or the id of the block immediately after this construct
  /// in the computed block order.
  const uint32_t end_id = 0;
  /// The position of block #begin_id in the computed block order.
  const uint32_t begin_pos = 0;
  /// The position of block #end_id in the block order, or the number of
  /// block order elements if #end_id is 0.
  const uint32_t end_pos = 0;
  /// The position of the first block after the WGSL scope corresponding to
  /// this construct.
  const uint32_t scope_end_pos = 0;
};

using ConstructList = std::vector<std::unique_ptr<Construct>>;

/// Converts a construct kind to a string.
/// @param kind the construct kind to convert
/// @returns the string representation
inline std::string ToString(Construct::Kind kind) {
  switch (kind) {
    case Construct::kFunction:
      return "Function";
    case Construct::kIfSelection:
      return "IfSelection";
    case Construct::kSwitchSelection:
      return "SwitchSelection";
    case Construct::kLoop:
      return "Loop";
    case Construct::kContinue:
      return "Continue";
  }
  return "NONE";
}

/// Converts a construct into a short summary string.
/// @param c the construct, which can be null
/// @returns a short summary string
inline std::string ToStringBrief(const Construct* c) {
  if (c) {
    std::stringstream ss;
    ss << ToString(c->kind) << "@" << c->begin_id;
    return ss.str();
  }
  return "null";
}

/// Emits a construct to a stream.
/// @param o the stream
/// @param c the structured construct
/// @returns the stream
inline std::ostream& operator<<(std::ostream& o, const Construct& c) {
  o << "Construct{ " << ToString(c.kind) << " [" << c.begin_pos << ","
    << c.end_pos << ")"
    << " begin_id:" << c.begin_id << " end_id:" << c.end_id
    << " depth:" << c.depth;

  o << " parent:" << ToStringBrief(c.parent);

  if (c.scope_end_pos != c.end_pos) {
    o << " scope:[" << c.begin_pos << "," << c.scope_end_pos << ")";
  }

  if (c.enclosing_loop) {
    o << " in-l:" << ToStringBrief(c.enclosing_loop);
  }

  if (c.enclosing_continue) {
    o << " in-c:" << ToStringBrief(c.enclosing_continue);
  }

  if ((c.enclosing_loop_or_continue_or_switch != c.enclosing_loop) &&
      (c.enclosing_loop_or_continue_or_switch != c.enclosing_continue)) {
    o << " in-c-l-s:" << ToStringBrief(c.enclosing_loop_or_continue_or_switch);
  }

  o << " }";
  return o;
}

/// Emits a construct to a stream.
/// @param o the stream
/// @param c the structured construct
/// @returns the stream
inline std::ostream& operator<<(std::ostream& o,
                                const std::unique_ptr<Construct>& c) {
  return o << *(c.get());
}

/// Converts a construct to a string.
/// @param c the construct
/// @returns the string representation
inline std::string ToString(const Construct& c) {
  std::stringstream ss;
  ss << c;
  return ss.str();
}

/// Converts a construct to a string.
/// @param c the construct
/// @returns the string representation
inline std::string ToString(const Construct* c) {
  return c ? ToString(*c) : ToStringBrief(c);
}

/// Converts a unique pointer to a construct to a string.
/// @param c the construct
/// @returns the string representation
inline std::string ToString(const std::unique_ptr<Construct>& c) {
  return ToString(*(c.get()));
}

/// Emits a construct list to a stream.
/// @param o the stream
/// @param cl the construct list
/// @returns the stream
inline std::ostream& operator<<(std::ostream& o, const ConstructList& cl) {
  o << "ConstructList{\n";
  for (const auto& c : cl) {
    o << "  " << c << "\n";
  }
  o << "}";
  return o;
}

/// Converts a construct list to a string.
/// @param cl the construct list
/// @returns the string representation
inline std::string ToString(const ConstructList& cl) {
  std::stringstream ss;
  ss << cl;
  return ss.str();
}

}  // namespace tint::reader::spirv

#endif  // SRC_TINT_READER_SPIRV_CONSTRUCT_H_
