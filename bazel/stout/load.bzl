"""Adds repostories/archives needed by stout."""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def stout_load(external = True):
    if external and "com_github_3rdparty_stout" not in native.existing_rules():
        git_repository(
            name = "com_github_3rdparty_stout",
            commit = "817fdd9935158280df9e5ccc601bfb9597cb3486",
            remote = "https://github.com/3rdparty/stout",
            shallow_since = "1616452946 -0700",
        )

    if "com_github_nelhage_rules_boost" not in native.existing_rules():
        git_repository(
            name = "com_github_nelhage_rules_boost",
            commit = "1e3a69bf2d5cd10c34b74f066054cd335d033d71",
            remote = "https://github.com/nelhage/rules_boost",
            shallow_since = "1591047380 -0700",
        )

    if "com_github_3rdparty_bazel_rules_picojson" not in native.existing_rules():
        git_repository(
            name = "com_github_3rdparty_bazel_rules_picojson",
            commit = "9196903bf30bd850cc0713d1c660d4755fee7a9b",
            remote = "https://github.com/3rdparty/bazel-rules-picojson",
            shallow_since = "1616433894 -0700",
        )

    if "com_github_3rdparty_bazel_rules_rapidjson" not in native.existing_rules():
        git_repository(
             name = "com_github_3rdparty_bazel_rules_rapidjson",
             commit = "6e735a0b2e7d125c776418b254648ab319289ccf",
             remote = "https://github.com/3rdparty/bazel-rules-rapidjson",
             shallow_since = "1616434870 -0700",
        )

    if "com_github_gflags_gflags" not in native.existing_rules():
        http_archive(
            name = "com_github_gflags_gflags",
            url = "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz",
            sha256 = "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf",
            strip_prefix = "gflags-2.2.2",
        )

    if "com_github_google_glog" not in native.existing_rules():
        http_archive(
            name = "com_github_google_glog",
            url = "https://github.com/google/glog/archive/v0.4.0.tar.gz",
            sha256 = "f28359aeba12f30d73d9e4711ef356dc842886968112162bc73002645139c39c",
            strip_prefix = "glog-0.4.0",
        )

