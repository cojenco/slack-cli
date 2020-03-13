#!/usr/bin/env ruby
require_relative 'workspace'


def display_options
  puts "\n\u{1f30f} Enter one of the following options \u{1f30f}"
  puts "1. list users"
  puts "2. list channels"
  puts "3. select user"
  puts "4. select channel"
  puts "5. details"
  puts "6. send message"
  puts "0. quit"
  puts "\n"
end

def get_id_name(recipient)
  puts "To select a #{recipient}, please enter a Slack ID or name:"
  user_input = gets.chomp
  return user_input
end

def prompt_message
  puts "Enter the message you want to send out:"
  user_input = gets.chomp
  return user_input
end

def pretty_line
  puts "*****************************************************************************"
end

def main
  pretty_line
  puts "\u{1F49B}\u{2764}\u{1F49A}\u{1F499}  Welcome to the Ada Slack CLI  \u{1F499}\u{1F49A}\u{2764}\u{1F49B}"
  workspace = SlackCLI::Workspace.new
  puts "A total of \u{1F4AC} #{workspace.channels.length} Channels and \u{1F596} #{workspace.users.length} Users have been loaded in this Workspace"
  pretty_line

  control_loop = true

  while control_loop
    display_options
    choice = gets.chomp
    case choice
      when "1", "list users"
        tp workspace.users, :slack_id, :name, :real_name
      when "2", "list channels"
        tp workspace.channels, :slack_id, :name, :topic, :member_count
      when "3", "select user"
        # user_input = get_id_name("user")
        begin
          chosen = workspace.select_user
        rescue ArgumentError => exception
          puts "Encountered an error: #{exception}"
        end
      when "4", "select channel"
        # user_input = get_id_name("channel")
        begin
          chosen = workspace.select_channel
        rescue ArgumentError => exception
          puts "Encountered an error: #{exception}"
        end
      when "5", "details"
        if workspace.selected != nil
          begin
            workspace.show_details
          rescue StandardError => exception
            puts "Encountered an error: #{exception}"
          end
        else
          puts "There is no recipient selected. Please select a user or channel first."
        end
      when "6", "send message"
        if workspace.selected != nil
          begin
            workspace.send_message
          rescue StandardError => exception
            puts "Encountered an error: #{exception}"
          end
        else
          puts "There is no recipient selected. Please select a user or channel first."
        end
      when "0", "quit", "exit"
        control_loop = false
    end
  end

  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME
