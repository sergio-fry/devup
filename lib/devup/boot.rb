if ENV.fetch("DEVUP_ENABLED", "true") == "true"
  devup = Devup::Environment.new pwd: `pwd`
  devup.up

  begin
    require "spring/commands"

    Spring.watch devup.root.join("docker-compose.yml")
  rescue LoadError, ArgumentError
    # Spring is not available
  end
end
