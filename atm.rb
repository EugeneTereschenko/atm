#!/usr/bin/env ruby
require "yaml"
require './bank_account.rb'

filebalance = ARGV.first || 'config.yml'

bank_account = BankAccount.new(filebalance)
bank_account.run

