"""Adds repositories/archives needed by stout."""

########################################################################
# DO NOT EDIT THIS FILE unless you are inside the
# https://github.com/3rdparty/stout repository. If you encounter it
# anywhere else it is because it has been copied there in order to
# simplify adding transitive dependencies. If you want a different
# version of stout follow the Bazel build instructions at
# https://github.com/3rdparty/stout.
########################################################################

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//3rdparty/bazel-rules-picojson:repos.bzl", picojson_repos = "repos")
load("//3rdparty/bazel-rules-rapidjson:repos.bzl", rapidjson_repos = "repos")

def repos(external = True, repo_mapping = {}):
    picojson_repos(
        repo_mapping = repo_mapping,
    )

    rapidjson_repos(
        repo_mapping = repo_mapping,
    )

    if "com_github_nelhage_rules_boost" not in native.existing_rules():
        git_repository(
            name = "com_github_nelhage_rules_boost",
            commit = "1e3a69bf2d5cd10c34b74f066054cd335d033d71",
            remote = "https://github.com/nelhage/rules_boost",
            shallow_since = "1591047380 -0700",
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

    if external and "com_github_3rdparty_stout" not in native.existing_rules():
        git_repository(
            name = "com_github_3rdparty_stout",
            commit = "67e6b9b08f340e223b741130815d97cf20296c08",
            remote = "https://github.com/3rdparty/stout",
            shallow_since = "1637367065 -0800",
        )
