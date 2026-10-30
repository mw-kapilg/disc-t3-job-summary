"""Render MATLAB JUnit test results and Cobertura coverage as job-summary Markdown.

Usage: python job_summary.py <junit.xml> <cobertura.xml>
Prints Markdown to stdout; missing or unreadable reports are noted, not fatal.
"""

import sys
import xml.etree.ElementTree as ET


def _parse(path):
    try:
        return ET.parse(path).getroot()
    except (OSError, ET.ParseError) as err:
        return err


def _pct(rate):
    return f"{float(rate) * 100:.1f}%"


def tests_section(path):
    root = _parse(path)
    lines = ["## Test results", ""]
    if isinstance(root, Exception):
        return lines + [f"_No test results found ({root})._", ""]

    passed, failed, skipped, problems = 0, 0, 0, []
    for case in root.iter("testcase"):
        name = f"{case.get('classname')}/{case.get('name')}"
        bad = case.find("failure")
        if bad is None:
            bad = case.find("error")
        if bad is not None:
            failed += 1
            message = (bad.get("message") or bad.text or "").strip()
            problems.append((name, message.splitlines()[0] if message else ""))
        elif case.find("skipped") is not None:
            skipped += 1
        else:
            passed += 1

    total = passed + failed + skipped
    status = ":x: Failed" if failed else ":white_check_mark: Passed"
    lines += [
        f"**{status}** - {passed} passed, {failed} failed, "
        f"{skipped} skipped/incomplete ({total} total)",
        "",
    ]
    if problems:
        lines += ["| Failed test | Message |", "| --- | --- |"]
        for name, message in problems:
            message = message.replace("|", "\\|")
            lines.append(f"| `{name}` | {message} |")
        lines.append("")
    return lines


def coverage_section(path):
    root = _parse(path)
    lines = ["## Code coverage", ""]
    if isinstance(root, Exception):
        return lines + [f"_No coverage report found ({root})._", ""]

    lines += [
        f"**Line coverage: {_pct(root.get('line-rate'))}** "
        f"({root.get('lines-covered')}/{root.get('lines-valid')} lines)",
        "",
        "| File | Line coverage | Missed lines |",
        "| --- | ---: | --- |",
    ]
    for cls in root.iter("class"):
        missed = [ln.get("number") for ln in cls.iter("line") if ln.get("hits") == "0"]
        lines.append(
            f"| `{cls.get('filename')}` | {_pct(cls.get('line-rate'))} "
            f"| {', '.join(missed) or '-'} |"
        )
    lines.append("")
    return lines


if __name__ == "__main__":
    junit, cobertura = sys.argv[1:3]
    print("\n".join(tests_section(junit) + coverage_section(cobertura)))
