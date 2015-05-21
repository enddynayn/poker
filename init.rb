### POKER ####
# Launch this Ruby file from the command line
###

require 'pry'
APP_ROOT = File.dirname(__FILE__)
$:.unshift( File.join(APP_ROOT, 'lib') )
require_relative 'deal'

Deal.cards

