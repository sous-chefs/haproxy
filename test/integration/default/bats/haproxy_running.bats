#!/usr/bin/env bats

@test "haproxy process in list" {
  run pgrep haproxy
}
