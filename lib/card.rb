# frozen_string_literal: true

class Card
  CARDS = {
    usual: {
      type: 'usual',
      number: 16.times.map{rand(10)}.join,
      balance: 50.00
    },
    capitalist: {
      type: 'capitalist',
      number: 16.times.map{rand(10)}.join,
      balance: 100.00
    },
    virtual: {
      type: 'virtual',
      number: 16.times.map{rand(10)}.join,
      balance: 150.00
    }
  }.freeze

  def create_card(current_account)
    loop do
      puts 'You could create one of 3 card types'
      puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
      puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
      puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
      puts '- For exit - press `exit`'

      card = case gets.chomp
      when CARDS[:usual][:type]
        CARDS[:usual]
      when CARDS[:capitalist][:type]
        CARDS[:capitalist]
      when CARDS[:virtual][:type]
        CARDS[:virtual]
      else puts "Wrong card type. Try again!\n"
      end

      if card
        cards = current_account.card << card
        # current_account.card = cards #important!!!
        new_accounts = []
        Account.new.accounts.each { |ac| ac.login == current_account.login ? new_accounts.push(current_account) : new_accounts.push(ac) }
        File.open(current_account.file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
        break
      end
    end
  end

  def show_cards(current_account)
    if current_account.card.any?
      current_account.card.each { |c| puts "- #{c[:number]}, #{c[:type]}" }
    else
      puts "There is no active cards!\n"
    end
  end

  def destroy_card(current_account)
    loop do
      if current_account.card.any?
        puts 'If you want to delete:'

        current_account.card.each_with_index { |c, i| puts "- #{c[:number]}, #{c[:type]}, press #{i + 1}" }
        puts "press `exit` to exit\n"
        answer = gets.chomp
        break if answer == 'exit'
        if answer&.to_i.to_i <= current_account.card.length && answer&.to_i.to_i > 0
          puts "Are you sure you want to delete #{current_account.card[answer&.to_i.to_i - 1][:number]}?[y/n]"
          a2 = gets.chomp
          if a2 == 'y'
            current_account.card.delete_at(answer&.to_i.to_i - 1)
            new_accounts = []
            Account.new.accounts.each { |ac| ac.login == current_account.login ? new_accounts.push(current_account) : new_accounts.push(ac) }
            File.open(current_account.file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
            break
          else
            return
          end
        else
          puts "You entered wrong number!\n"
        end
      else
        puts "There is no active cards!\n"
        break
      end
    end
  end
end
