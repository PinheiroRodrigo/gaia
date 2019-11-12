import Config

config :gaia,
  ecto_repos: [Gaia.Repo]

config :gaia, Gaia.Repo,
  database: "gaia_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432
