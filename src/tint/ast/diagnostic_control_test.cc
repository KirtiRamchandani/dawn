// Copyright 2023 The Tint Authors.
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

////////////////////////////////////////////////////////////////////////////////
// File generated by tools/src/cmd/gen
// using the template:
//   src/tint/ast/diagnostic_control_test.cc.tmpl
//
// Do not modify this file directly
////////////////////////////////////////////////////////////////////////////////

#include <string>

#include "gtest/gtest-spi.h"
#include "src/tint/ast/diagnostic_control.h"
#include "src/tint/ast/test_helper.h"

namespace tint::ast {
namespace {

using DiagnosticControlTest = TestHelper;

TEST_F(DiagnosticControlTest, Creation) {
    auto* name = Ident("foo");
    Source source;
    source.range.begin = Source::Location{20, 2};
    source.range.end = Source::Location{20, 5};
    auto* control = create<ast::DiagnosticControl>(source, DiagnosticSeverity::kWarning, name);
    EXPECT_EQ(control->source.range.begin.line, 20u);
    EXPECT_EQ(control->source.range.begin.column, 2u);
    EXPECT_EQ(control->source.range.end.line, 20u);
    EXPECT_EQ(control->source.range.end.column, 5u);
    EXPECT_EQ(control->severity, DiagnosticSeverity::kWarning);
    EXPECT_EQ(control->rule_name, name);
}

TEST_F(DiagnosticControlTest, Assert_RuleNotTemplated) {
    EXPECT_FATAL_FAILURE(
        {
            ProgramBuilder b;
            b.create<ast::DiagnosticControl>(DiagnosticSeverity::kWarning,
                                             b.Ident("name", "a", "b", "c"));
        },
        "internal compiler error");
}

namespace diagnostic_severity_tests {

namespace parse_print_tests {

struct Case {
    const char* string;
    DiagnosticSeverity value;
};

inline std::ostream& operator<<(std::ostream& out, Case c) {
    return out << "'" << std::string(c.string) << "'";
}

static constexpr Case kValidCases[] = {
    {"error", DiagnosticSeverity::kError},
    {"info", DiagnosticSeverity::kInfo},
    {"off", DiagnosticSeverity::kOff},
    {"warning", DiagnosticSeverity::kWarning},
};

static constexpr Case kInvalidCases[] = {
    {"erccr", DiagnosticSeverity::kUndefined},    {"3o", DiagnosticSeverity::kUndefined},
    {"eVror", DiagnosticSeverity::kUndefined},    {"1nfo", DiagnosticSeverity::kUndefined},
    {"iqfJ", DiagnosticSeverity::kUndefined},     {"illf77", DiagnosticSeverity::kUndefined},
    {"oppqH", DiagnosticSeverity::kUndefined},    {"", DiagnosticSeverity::kUndefined},
    {"Gb", DiagnosticSeverity::kUndefined},       {"warniivg", DiagnosticSeverity::kUndefined},
    {"8WWrning", DiagnosticSeverity::kUndefined}, {"wxxning", DiagnosticSeverity::kUndefined},
};

using DiagnosticSeverityParseTest = testing::TestWithParam<Case>;

TEST_P(DiagnosticSeverityParseTest, Parse) {
    const char* string = GetParam().string;
    DiagnosticSeverity expect = GetParam().value;
    EXPECT_EQ(expect, ParseDiagnosticSeverity(string));
}

INSTANTIATE_TEST_SUITE_P(ValidCases, DiagnosticSeverityParseTest, testing::ValuesIn(kValidCases));
INSTANTIATE_TEST_SUITE_P(InvalidCases,
                         DiagnosticSeverityParseTest,
                         testing::ValuesIn(kInvalidCases));

using DiagnosticSeverityPrintTest = testing::TestWithParam<Case>;

TEST_P(DiagnosticSeverityPrintTest, Print) {
    DiagnosticSeverity value = GetParam().value;
    const char* expect = GetParam().string;
    EXPECT_EQ(expect, utils::ToString(value));
}

INSTANTIATE_TEST_SUITE_P(ValidCases, DiagnosticSeverityPrintTest, testing::ValuesIn(kValidCases));

}  // namespace parse_print_tests

}  // namespace diagnostic_severity_tests

namespace diagnostic_rule_tests {

namespace parse_print_tests {

struct Case {
    const char* string;
    DiagnosticRule value;
};

inline std::ostream& operator<<(std::ostream& out, Case c) {
    return out << "'" << std::string(c.string) << "'";
}

static constexpr Case kValidCases[] = {
    {"chromium_unreachable_code", DiagnosticRule::kChromiumUnreachableCode},
    {"derivative_uniformity", DiagnosticRule::kDerivativeUniformity},
};

static constexpr Case kInvalidCases[] = {
    {"cXromggum_unreachable_cde", DiagnosticRule::kUndefined},
    {"chroVium_unruchble_codX", DiagnosticRule::kUndefined},
    {"chromium_3nreachable_code", DiagnosticRule::kUndefined},
    {"derivatEve_uniformity", DiagnosticRule::kUndefined},
    {"deTTPivative_uniformit", DiagnosticRule::kUndefined},
    {"derivtive_uddxxformity", DiagnosticRule::kUndefined},
};

using DiagnosticRuleParseTest = testing::TestWithParam<Case>;

TEST_P(DiagnosticRuleParseTest, Parse) {
    const char* string = GetParam().string;
    DiagnosticRule expect = GetParam().value;
    EXPECT_EQ(expect, ParseDiagnosticRule(string));
}

INSTANTIATE_TEST_SUITE_P(ValidCases, DiagnosticRuleParseTest, testing::ValuesIn(kValidCases));
INSTANTIATE_TEST_SUITE_P(InvalidCases, DiagnosticRuleParseTest, testing::ValuesIn(kInvalidCases));

using DiagnosticRulePrintTest = testing::TestWithParam<Case>;

TEST_P(DiagnosticRulePrintTest, Print) {
    DiagnosticRule value = GetParam().value;
    const char* expect = GetParam().string;
    EXPECT_EQ(expect, utils::ToString(value));
}

INSTANTIATE_TEST_SUITE_P(ValidCases, DiagnosticRulePrintTest, testing::ValuesIn(kValidCases));

}  // namespace parse_print_tests

}  // namespace diagnostic_rule_tests

}  // namespace
}  // namespace tint::ast
