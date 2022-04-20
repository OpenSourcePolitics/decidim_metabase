#!/usr/bin/env ruby

require_relative "lib/decidim_metabase"
require "byebug"
require 'faraday'
require 'faraday/net_http'
require 'dotenv/load'


def render_ascii_art
  File.readlines("ascii.txt")[0..-2].each do |line|
    puts line
  end
  puts "                     Module Metabase (v#{DecidimMetabase::VERSION})"
  puts "                     By Open Source Politics."
  puts "\n"
end

render_ascii_art

## Interesting things below...

begin

TOKEN_DB_PATH="token.private"
Faraday.default_adapter = :net_http

conn = Faraday.new(
  url: "https://#{ENV.fetch("METABASE_HOST")}/",
  headers: {'Content-Type' => 'application/json'}
)

api_session = DecidimMetabase::Api::Session.new(conn, {
  username: ENV.fetch("METABASE_USERNAME"),
  password: ENV.fetch("METABASE_PASSWORD"),
})

puts api_session.token
puts api_session.session_request_header

rescue StandardError => e
  puts "[#{e.class}] - #{e.message} (Exit code: 2)"
  exit 2
end

