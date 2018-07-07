module CoreExtensions
  module IPAddr
    def to_cidr_s
      return to_s if @mask_addr == 4294967295
      if @addr
        mask = @mask_addr.to_s(2).count('1')
        "#{to_s}/#{mask}"
      else
        nil
      end
    end
  end
end

IPAddr.include CoreExtensions::IPAddr


