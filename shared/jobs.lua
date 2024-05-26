QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
QBShared.Jobs = {
	unemployed = { label = 'Civilian', defaultDuty = true, offDutyPay = false, grades = { { name = 'Freelancer', payment = 10 } } },

	police = {
		label = 'Law Enforcement',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recrue', payment = 50 },
			{ name = 'Cadet', payment = 75 },
			{ name = 'Officier I', payment = 100 },
			{ name = 'Officier II', payment = 125 },
            { name = 'Officier III', payment = 125 },
            { name = 'Détective I', payment = 125 },
            { name = 'Détective II', payment = 125 },
            { name = 'Détective III', payment = 125 },
            { name = 'Détective IV', payment = 125 },
            { name = 'SLO', payment = 125 },
            { name = 'Sergent', payment = 125 },
            { name = 'Lieutenant', payment = 125 },
			{ name = 'Capitaine', isboss = true, payment = 150 },
		},
	},

	ambulance = {
		label = 'EMS',
		type = 'ems',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Paramedic', payment = 75 },
			{ name = 'Doctor', payment = 100 },
			{ name = 'Surgeon', payment = 125 },
			{ name = 'Chief', isboss = true, payment = 150 },
		},
	},

    realestate = {
		label = 'Immobilier',
		type = 'realestate',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    cardealer = {
		label = 'Concession Automobile',
		type = 'cardealer',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    mechanic = {
		label = 'BENNY\'S',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    barber = {
		label = 'Coiffeur',
		type = 'barber',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    bikedealer = {
		label = 'Concession Moto',
		type = 'bikedealer',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    burgershot = {
		label = 'Burgershot',
		type = 'burgershot',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    divin = {
		label = 'Divin',
		type = 'divin',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    farmer = {
		label = 'Miller\'s Farm',
		type = 'farmer',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    government = {
		label = 'Gouvernement',
		type = 'government',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    grandemotors = {
		label = 'Grande Motors',
		type = 'grandemotors',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    ikea = {
		label = 'IKEA',
		type = 'ikea',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    mcevent = {
		label = 'MC Event',
		type = 'mcevent',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    mcnews = {
		label = 'MC News',
		type = 'mcnews',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    ranch = {
		label = 'Ranch',
		type = 'ranch',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    refinery = {
		label = 'Petrolium',
		type = 'refinery',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    tabac = {
		label = 'Tabarico',
		type = 'tabac',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    tattooshop = {
		label = 'Blazing Tattoo',
		type = 'tattooshop',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    tequilala = {
		label = 'Tequilala',
		type = 'tequilala',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    transistep = {
		label = 'Transistep',
		type = 'transistep',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    unicorn = {
		label = 'Unicorn',
		type = 'unicorn',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    vineyard = {
		label = 'Vignoble',
		type = 'vineyard',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},

    foundry = {
		label = 'Fonderie',
		type = 'foundry',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},
}
