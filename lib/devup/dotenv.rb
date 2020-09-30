require "dotenv"

Dotenv.load(
  ".env.development.local", ".env.test.local", ".env.production.local", ".env.local",
  ".env.services",
  ".env.development", ".env.test", ".env.production",
  ".env"
)
