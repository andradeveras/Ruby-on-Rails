namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") do 
        %x(rails db:drop)
      end
      show_spinner("Criando BD...") { %x(rails db:create) } #Forma de reduzir ainda mais o Código
      show_spinner("Migrando Tabelas...") { %x(rails db:migrate) }
      %x(rails dev:add_coins)
      %x(rails dev:add_mining_types)
  
    else
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end


  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins = [

        {
          description: "Bitcoin",
          acronym: "BTC",
          url_image: "https://imagensemoldes.com.br/wp-content/uploads/2020/09/Logo-Bitcoin-PNG.png"
        },

        {
          description: "Ethereum",
          acronym: "ETH",
          url_image: "https://w7.pngwing.com/pngs/268/1013/png-transparent-ethereum-eth-hd-logo-thumbnail.png"
        },

        {
          description: "Dash",
          acronym: "DASH",
          url_image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBCRnYfsVucKrAJ27qkTVHL8aSTN5ucKHL2Sa-eVqZVg&s"
        },

        {
          description: "Iota",
          acronym: "IOT",
          url_image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQu5t32U4-ke52xz-JIC-fsUSwZK_mVzGdVnW_E3FXGd7_0fQBT9JaYx_XtYoGXsPst1B0&usqp=CAU"
        },

        {
          description: "ZCash",
          acronym: "ZEC",
          url_image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkRL7oZ4vpPewFw6IGh1XQ5F6tNsBvVwJPMwFrHRmZH7JHUXqyB1O60U7-pJVs-AKzVS0&usqp=CAU"
        }   
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipod de mineiração...") do
      mining_types = [
        {description:"Proof of Work", acronym: "Pow"},
        {description:"Proof of Stake", acronym: "PoS"},
        {description:"Proof of Capacity", acronym: "PoC"}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

private# A partir daqui para baixo todo código será privado e este método só poderá ser usado aqui.
  def show_spinner(msg_start, msg_end="Concluido")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin # Automatic animation with default interval
    yield
    spinner.success("(#{msg_end})")
  end
end
