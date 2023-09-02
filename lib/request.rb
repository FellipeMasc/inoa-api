class Request < RuntimeError
  require 'uri'
  require 'net/http'
  require 'openssl'

  def self.api_call(symbol, interval, timeout = 150)

    recomendacoes = []
    symbol = JSON.parse(symbol)
    
    ativos_list = []
    symbol.map do |ativo_info|
      ativos_list << ativo_info["nome_ativo"]
    end
    ativos_hash = ativos_list.join(",") 
    
    uri = URI("https://brapi.dev/api/quote/#{ativos_hash}?token=#{ENV["API_KEY"]}&interval=1m")
    resp = Net::HTTP.get(uri)
    resp = JSON.parse(resp)

    resp["results"].map do |ativo|
      current_ativo = symbol.detect{ |i| i["nome_ativo"] == ativo["symbol"]}
      preco_compra = current_ativo["preco_compra"]
      preco_venda = current_ativo["preco_venda"]

      if ativo["regularMarketPrice"] >= preco_venda.to_f
        recomendacoes << {
          ativo: current_ativo["nome_ativo"],
          recomendacao: "Vender"
        }
      elsif ativo["regularMarketPrice"] <= preco_compra.to_f
        recomendacoes << {
          ativo: current_ativo["nome_ativo"],
          recomendacao: "Comprar"
        }
      end

    end

    return recomendacoes

  end

  def self.api_data_series(symbol, interval)
    ativos_data_series = []
    symbol = JSON.parse(symbol)
    
    ativos_list = []
    symbol.map do |ativo_info|
      ativos_list << ativo_info["nome_ativo"]
    end
    ativos_hash = ativos_list.join(",")

    uri = URI("https://brapi.dev/api/quote/#{ativos_hash}?token=#{ENV["API_KEY"]}&interval=#{interval}m&range=1d")
    # uri = URI("https://brapi.dev/api/quote/PETR4,VIVA3?token=#{ENV["API_KEY"]}&interval=1m&range=1d")
    resp = Net::HTTP.get(uri)
    resp = JSON.parse(resp)
    
    resp["results"].map do |ativo|
      data = ativo["historicalDataPrice"].map do |serie|
        if !serie["open"] || !serie["high"] || !serie["low"] || !serie["close"]
          next
        end
        {
          x: serie["date"],
          y: [ serie["open"], serie["high"], serie["low"], serie["close"] ]
        }
      end
      ativos_data_series << {
        ativo_nome: ativo["symbol"],
        ativo_logo: ativo["logourl"],
        data: data.compact  
      }
    end


    ativos_data_series

  end

end



