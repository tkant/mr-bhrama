# Mr Bhrama - The AI Tutor Bot

I trust you're all enjoying the influx of exciting technologies. I'm thrilled to unveil the result of a recent hackathon endeavor – a project I developed in just around 7-8 hours. This creation synergizes the capabilities of generative AI with the realm of education.

It's a bot using GPT-4 model, integrated with Phoenix (Elixir language based framework) backed by PostgreSQL. It is tailored to assist high-school students, from grade levels 1 to 12, as well as those pursuing engineering degrees, its all the game of setting the right depth using simplest prompt engineering patterns.

## Demo

https://github.com/tkant/mr-bhrama/assets/11471896/4c515c75-9bde-4536-90b7-69e1bbad4e9b

The system can be run locally or deployed on https://fly.io by following the instructions in the README.md. The endpoint, `/chat/:ANY_USER_NAME:?class=[:DEPTH:]`, accommodates a range of interactions, covering classes from 1 to 12, as well as academic levels like "undergraduate," "graduate," and beyond. It retains the context of the user's identity and their current educational focus, ensuring alignment with their age or curriculum level.

Special thanks to - https://github.com/JushBJJ/Mr.-Ranedeer-AI-Tutor

## Running Locally

To start your Phoenix server:

  * Run `docker compose up -d` in deamon mode for booting up PostGres DB
  * Get your OPEN-AI Key, remember to use the GPT-4 version
  * `export OPENAI_API_KEY="YOUR_OPEN_AI_KEY"` - Should be GPT-4 based for optimal response.
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
