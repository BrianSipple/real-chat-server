ExUnit.start

Mix.Task.run "ecto.create", ~w(-r RealChat.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r RealChat.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(RealChat.Repo)

