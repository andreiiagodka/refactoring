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
end
