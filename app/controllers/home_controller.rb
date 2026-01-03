require 'cgi'

class HomeController < ApplicationController
  PUBLIC_ENV_KEYS = %w[APP_NAME API_URL ENVIRONMENT VERSION].freeze
  PRIVATE_ENV_KEYS = %w[DATABASE_URL API_SECRET_KEY].freeze

  def index
    render html: env_demo_html.html_safe
  end

  def health
    render json: {
      status: 'ok',
      environment: Rails.env,
      timestamp: Time.current
    }
  end

  def env
    render json: public_env
  end

  private

  def public_env
    PUBLIC_ENV_KEYS.to_h { |key| [key, env_plain_value(key)] }
  end

  def private_env
    PRIVATE_ENV_KEYS.to_h { |key| [key, env_plain_value(key)] }
  end

  def env_demo_html
    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <title>Server Compass Env Demo</title>
          <style>
            :root {
              --bg: #0f172a;
              --panel: rgba(255, 255, 255, 0.08);
              --card: rgba(255, 255, 255, 0.06);
              --text: #e2e8f0;
              --muted: #94a3b8;
              --accent: #60a5fa;
              --accent-2: #c084fc;
              --border: rgba(255, 255, 255, 0.16);
              --shadow: 0 18px 35px rgba(0, 0, 0, 0.35);
              --radius: 18px;
            }
            * { box-sizing: border-box; }
            body {
              margin: 0;
              padding: 0;
              font-family: "Inter", "Segoe UI", system-ui, -apple-system, sans-serif;
              background: radial-gradient(circle at 20% 20%, rgba(96,165,250,0.18), transparent 30%),
                          radial-gradient(circle at 80% 0%, rgba(192,132,252,0.12), transparent 25%),
                          var(--bg);
              color: var(--text);
              min-height: 100vh;
              display: flex;
              align-items: center;
              justify-content: center;
              padding: 32px 18px;
            }
            .shell {
              width: min(900px, 100%);
              background: var(--panel);
              border: 1px solid var(--border);
              border-radius: 22px;
              box-shadow: var(--shadow);
              backdrop-filter: blur(8px);
              padding: 32px;
            }
            header {
              display: flex;
              justify-content: space-between;
              align-items: center;
              gap: 12px;
              margin-bottom: 16px;
            }
            .badge {
              padding: 6px 12px;
              border-radius: 999px;
              background: linear-gradient(120deg, rgba(96,165,250,0.35), rgba(192,132,252,0.35));
              color: #0b1221;
              font-weight: 700;
              font-size: 12px;
              letter-spacing: 0.02em;
              text-transform: uppercase;
            }
            h1 { margin: 0; font-size: 26px; }
            p.lede { margin: 6px 0 24px; color: var(--muted); }
            .grid {
              display: grid;
              grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
              gap: 16px;
            }
            .card {
              background: var(--card);
              border: 1px solid var(--border);
              border-radius: var(--radius);
              padding: 18px 18px 12px;
              position: relative;
              overflow: hidden;
            }
            .card h2 {
              margin: 0 0 12px;
              font-size: 16px;
              letter-spacing: 0.01em;
            }
            dl { margin: 0; }
            .row {
              display: grid;
              grid-template-columns: 120px 1fr;
              gap: 10px;
              padding: 10px 0;
              border-bottom: 1px solid var(--border);
            }
            .row:last-child { border-bottom: none; }
            dt { font-weight: 600; color: var(--muted); }
            dd { margin: 0; font-weight: 700; color: var(--text); }
            .muted { color: var(--muted); }
            .accent { color: var(--accent); }
            @media (max-width: 520px) {
              .row { grid-template-columns: 1fr; }
              header { flex-direction: column; align-items: flex-start; }
            }
          </style>
        </head>
        <body>
          <main class="shell">
            <header>
              <h1>Server Compass Env Demo</h1>
              <span class="badge">Rails 5.2 API</span>
            </header>
            <p class="lede">Live view of environment values. Unset variables show <span class="muted">Not set</span>.</p>
            <div class="grid">
              #{env_section('Public variables', PUBLIC_ENV_KEYS)}
              #{env_section('Private variables', PRIVATE_ENV_KEYS, emphasize: true)}
            </div>
          </main>
        </body>
      </html>
    HTML
  end

  def env_section(title, keys, emphasize: false)
    rows = keys.map do |key|
      value = env_value(key)
      %(
        <div class="row">
          <dt>#{key}</dt>
          <dd class="#{value == 'Not set' ? 'muted' : (emphasize ? 'accent' : '')}">#{value}</dd>
        </div>
      )
    end.join

    <<~HTML
      <section class="card">
        <h2>#{title}</h2>
        <dl>
          #{rows}
        </dl>
      </section>
    HTML
  end

  def env_value(key)
    value = env_plain_value(key)
    value == 'Not set' ? value : CGI.escape_html(value)
  end

  def env_plain_value(key)
    raw = env_raw_value(key)
    raw.present? ? raw : 'Not set'
  end

  def env_raw_value(key)
    return ENV['SERVER_COMPASS_DEMO_VERSION'] || ENV['VERSION'] if key == 'VERSION'
    return ENV['SERVER_COMPASS_DEMO_DATABASE_URL'] || ENV['DATABASE_URL'] if key == 'DATABASE_URL'

    ENV[key]
  end
end
