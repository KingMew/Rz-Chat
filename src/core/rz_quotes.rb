class RzQuote
	def initialize
		@clifford_quotes = [
			"Do you ever... wonder who you are?",
			"When everyone lives in the future, the present is au revoir."
			"Smelly Tongues Looked Just as They Felt!",
			"How much marriage urges a windmill to pinch infinity?",
			"Welcome to the offshoots of Jupiter.",
			"Can tomorrow be more than the end of today?",
			"Here I come, Constantinople!",
			"Your heart is like a silken sponge that calls saliva love.",
			"A coma with a sweet aroma is your only dream",
			"Infection is your finest flower mildewed in the mist.",
			"Without a beat they march along believing Bach is dead.",
			"Straight to the top, I'll never stop, I'll die before my day.",
			"You care for plants and we care for you",
			"I wonder how the world could be a perfect place to sin about for anyone but me;",
			"All that God wanted to be was just a normal deity",
			"Chew chew GUM chew GUM GUM chew chew",
			"Coca-Cola adds life",
			"The only really perfect love is one that gets away",
			"They're always touching, always looking, in a secret way. I thought that I might cut them deep",
			"I was just exhausted from the act of being polite",
			"We are simple, you are simple, life is simple, too.",
			"Mumbling weighs upon my mind, the talk of creatures in my spine",
			"I thought about her fingertips, and not her lack of grace"
		]
		@other_quotes = [
			"People should be left alone, unless they have a happy home.",
			"We're marching to the sea, marching to the sea.",
			"Need work? Need work? Sign here, sign here!",
			"Is anybody driving? Someone's gotta be, somebody driving?",
			"If there was no desperation would we be alive?",
			"Truth comes out of fiction, love comes out of friction. Purity is interesting, but so is superstition",
			"I care so very much for her, I just want her shoes to fit her",
			"Yesterday we found a purse. Today we found some glass",
			"Do not forget my face, my friend, for if you do I'm dead",
			"I'm Mr. X who wants to come and who expects to help and guide your efforts to succeed",
			"Don't you see there is no 'she' now?",
			"His dying eyes are with me... from the plains to Mexico.",
			"Everyone comes to the Freak Show but nobody laughs when they leave.",
			"I wish I was a cowboy or maybe just a bird",
			"Some say the song of a crow is a cry",
			"Some say the song of a crow is a lie",
			"There's supposed to be a beautiful blue light ...but all I saw was eels",
			"I was lifted up high to a hole in the sky",
			"What have my chickens done now?",
			"Oh, we have to buy a tulip!",
			"I ride the river of crime",
			"Bitter is the aftertaste of a dream that dies",
			"Some people like cruel lovers, some like giving lovers, some like submissive, some like strong.",
			"And that's why God made alcohol ...especially bourbon.",
			"There's nothing there that cares for silly children on the moon",
			"Let our love become the seeds that turn into tomorrow.",
			"I guess even the Sandman must feel some kind of love...",
			"Love is a skeleton key unlocking a small room filled with darkness and hope.",
			"When I was a lonely teenager...",
			"I was a ping pong ball a jet black ping pong ball",
			"I love the rabbits and I know the rabbits love me",
			"Life is a lonely train wracked by God",
			"The Ghost of Hope said NO!",
			"Such a fire you never saw. It was an oil fire... AN OIL FIRE!",
			"I have seen his face before, and yes I even know his name.",
			"This is your invitation to the Theory of Obscurity!",
			"Who - threw the voodoo doll at me?",
			"I'm sitting here now eating a bacon cheeseburger... with two patties!!!"
		]
	end

	def get_all_quotes(clifford=false)
		if clifford
			@clifford_quotes
		else
			@clifford_quotes + @other_quotes
		end
	end

	def quote(clifford=false)
		get_all_quotes(clifford).sample
	end
end
