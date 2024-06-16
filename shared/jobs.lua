QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
QBShared.Jobs = {
	unemployed = {
        label = 'Civil',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            { name = 'Sans Emploi', payment = 10 }
        }
    },

	police = {
		label = 'LSPD',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Recrue', payment = 50 },
			{ name = 'Cadet', payment = 75 },
			{ name = 'Officier I', payment = 100 },
			{ name = 'Officier II', payment = 125 },
            { name = 'Officier III', payment = 125 },
            { name = 'Détective', payment = 125 },
            { name = 'SLO', payment = 125 },
            { name = 'Sergent', payment = 125 },
            { name = 'Sergent II', payment = 125 },
            { name = 'Lieutenant', payment = 125 },
			{ name = 'Capitaine', isboss = true, payment = 150 },
            { name = 'Commandant', isboss = true, payment = 150 },
		},
	},

    ambulance = {
		label = 'EMS',
		type = 'ems',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Urgentiste', payment = 50 },
			{ name = 'Docteur', payment = 75 },
			{ name = 'Chef de Service', payment = 100 },
			{ name = 'Vice-Directeur', payment = 125 },
			{ name = 'Queen', isboss = true, payment = 150 },
		},
	},

    government = {
		label = 'Gouvernement',
		type = 'government',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Conseiller du Gouvernement', payment = 50 },
			{ name = 'Procureur', payment = 75 },
			{ name = 'Juge', payment = 100 },
			{ name = 'Gouverneur-Adjoint', isboss = true, payment = 125 },
			{ name = 'Gouverneur', isboss = true, payment = 150 },
		},
	},

    lawyer = {
		label = 'Bureau d\'Avocats',
		type = 'lawyer',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Stagiaire', payment = 50 },
			{ name = 'Avocat', payment = 75 },
			{ name = 'Patron', isboss = true, payment = 100 },
		},
	},

    mcnews = {
		label = 'Weazel News',
		type = 'mcnews',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Technicien', payment = 50 },
			{ name = 'Journaliste', payment = 75 },
			{ name = 'Rédacteur en Chef', payment = 100 },
			{ name = 'Présentateur', payment = 125 },
			{ name = 'Directeur Général', isboss = true, payment = 150 },
		},
	},

    grandemotors = {
		label = 'Grande Motors',
		type = 'grandemotors',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			{ name = 'Mécano', payment = 50 },
			{ name = 'Mécanicien', payment = 75 },
			{ name = 'Mécanicien Chef', payment = 100 },
			{ name = 'Chef D\'Atelier', payment = 125 },
			{ name = 'Patron', isboss = true, payment = 150 },
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

    pizzeria = {
		label = 'All\'Oro',
		type = 'pizzeria',
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

    blacktop = {
		label = 'The BlackTop',
		type = 'blacktop',
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



    youtool = {
		label = 'IKEA',
		type = 'youtool',
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

	chickndrive = {
		label = 'Chick\'n Drive',
		type = 'chickndrive',
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

	sandwichbar = {
		label = 'Chez Denis',
		type = 'sandwichbar',
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

	yellowjack = {
		label = 'Yellow Jack',
		type = 'yellowjack',
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

	salieris = {
		label = 'Bar Pisoni',
		type = 'salieris',
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

    taxi = {
		label = 'My Taxis',
		type = 'taxi',
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
