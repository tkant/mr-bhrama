# Bhrama

To start your Phoenix server:

  * Run `docker compose up -d` in deamon mode for booting up PostGres DB
  * `export OPENAI_API_KEY="YOUR_OPEN_AI_KEY"`
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/chat/john?class=4`](localhost:4000/chat/john?class=4) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


## Deploy commands

```bash
flyctl auth login

# One time to create required instances
fly launch

# To deploy post changes
fly deploy

fly scale count 0 --app "mr-bhrama"
```
