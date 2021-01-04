# :erlang.system_flag( :schedulers_online, 1)

# timeout set for debugging with iex -S mix test
ExUnit.configure(exclude: [:meta, :wip], timeout: 10_000_000)
# timeout set for tests w/o debugging
# ExUnit.configure(exclude: [:meta, :wip])
ExUnit.start()

# SPDX-License-Identifier: Apache-2.0
