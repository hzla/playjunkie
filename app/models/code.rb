class Code

	def self.generate
		random = (48..122).map {|x| x.chr}
    characters = (random - random[43..48] - random[10..16])
    code = characters.map {|c| characters.sample}
    code.join[0..15]
	end


end