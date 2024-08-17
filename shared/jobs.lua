QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
QBShared.Jobs = {
	unemployed = {
        label = 'Civil',
        defaultDuty = true,
        offDutyPay = true,
        grades = {
            { name = 'Sans Emploi', payment = 20 }
        }
    },

	police = {
		label = 'LSPD',
		type = 'leo',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Recrue', payment = 50 },
			{ name = 'Cadet', payment = 75 },
			{ name = 'Officier I', payment = 100 },
			{ name = 'Officier II', payment = 125 },
            { name = 'Officier III', payment = 125 },
            { name = 'Détective', payment = 125 },
            { name = 'SLO', payment = 125 },
            { name = 'Sergent I', payment = 125 },
            { name = 'Sergent II', payment = 125 },
            { name = 'Lieutenant', payment = 125 },
			{ name = 'Capitaine', isboss = true, payment = 150 },
            { name = 'Commandant', isboss = true, payment = 150 },
		},
	},

    ambulance = {
		label = 'EMS',
		type = 'ems',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
            { name = 'Personnel', payment = 50 },
			{ name = 'Urgentiste', payment = 50 },
			{ name = 'Docteur', payment = 75 },
			{ name = 'Chef de Service', payment = 100 },
			{ name = 'Vice-Directeur', isboss = true, payment = 125 },
			{ name = 'Queen', isboss = true, payment = 150 },
		},
	},

    government = {
		label = 'Gouvernement',
		type = 'government',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
            { name = 'Agent d\'Accueil', payment = 50 },
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
		defaultDuty = false,
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
		defaultDuty = false,
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
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Mécano', payment = 50 },
			{ name = 'Mécanicien', payment = 75 },
			{ name = 'Mécanicien Chef', payment = 100 },
			{ name = 'Chef D\'Atelier', payment = 125 },
            { name = 'Co-Patron', isboss = true, payment = 150 },
			{ name = 'Patron', isboss = true, payment = 150 },
		},
	},

    mechanic = {
		label = 'BENNY\'S',
		type = 'mechanic',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Stagiaire', payment = 50 },
			{ name = 'Employé', payment = 75 },
			{ name = 'Chef d\'atelier', payment = 100 },
			{ name = 'Co patron', payment = 125 },
			{ name = 'Patron', isboss = true, payment = 150 },
		},
	},

    cardealer = {
		label = 'Premium Deluxe Motorsport',
		type = 'cardealer',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'A l\'essai', payment = 50 },
			{ name = 'Vendeur', payment = 75 },
			{ name = 'Responsable', payment = 100 },
			{ name = 'DRH', payment = 125 },
			{ name = 'Directeur Adjoint', isboss = true, payment = 150 },
            { name = 'Directeur', isboss = true, payment = 150 },
		},
	},

    bikedealer = {
		label = 'Harmony Motors',
		type = 'bikedealer',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Recrue', payment = 50 },
			{ name = 'Employé', payment = 75 },
			{ name = 'Employé Confirmé', payment = 100 },
			{ name = 'Chef d\'équipe', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
            { name = 'Co-PDG', isboss = true, payment = 150 },
            { name = 'PDG', isboss = true, payment = 150 },
		},
	},

    farmer = {
		label = 'La Ferme des 4 Saisons',
		type = 'farmer',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Intérimaire', payment = 50 },
			{ name = 'Fermier', payment = 75 },
			{ name = 'Chef d\'équipe', payment = 100 },
			{ name = 'Co-PDG', isboss = true, payment = 125 },
			{ name = 'PDG', isboss = true, payment = 150 },
		},
	},

    ranch = {
		label = 'Red River Ranch',
		type = 'ranch',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Interim', payment = 50 },
			{ name = 'Employé', payment = 75 },
			{ name = 'Chef d\'équipe', payment = 100 },
			{ name = 'DRH', payment = 125 },
			{ name = 'Co-Patron', isboss = true, payment = 150 },
            { name = 'Patron', isboss = true, payment = 150 },
		},
	},

    refinery = {
		label = 'Petrolium',
		type = 'refinery',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Chauffeur Novice', payment = 50 },
			{ name = 'Chauffeur Intermédiaire', payment = 75 },
			{ name = 'Chauffeur Expérimenté ', payment = 100 },
			{ name = 'Chef d\'équipe', payment = 125 },
			{ name = 'Chauffeur Formateur', payment = 150 },
            { name = 'Co-Patron', isboss = true, payment = 150 },
            { name = 'Patron', isboss = true, payment = 150 },
		},
	},

    foundry = {
		label = 'Jerimac Mine',
		type = 'foundry',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Saisonnier/Interim', payment = 50 },
			{ name = 'Apprenti', payment = 75 },
			{ name = 'Employé', payment = 100 },
			{ name = 'Chef', payment = 125 },
			{ name = 'Co-Patron', isboss = true, payment = 150 },
            { name = 'Patron', isboss = true, payment = 150 },
		},
	},

    vineyard = {
		label = 'Kalypso',
		type = 'vineyard',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Ouvrier', payment = 50 },
			{ name = 'Employé', payment = 75 },
			{ name = 'Gérant', payment = 100 },
			{ name = 'Co-Patron', isboss = true, payment = 125 },
            { name = 'Patron', isboss = true, payment = 125 },
		},
	},

    mcevent = {
		label = 'MC Event',
		type = 'mcevent',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Coordinateur', payment = 50 },
			{ name = 'Chef de la com', payment = 75 },
			{ name = 'Chef de la prod', payment = 100 },
			{ name = 'Directeur/trice', isboss = true, payment = 125 },
		},
	},

    transistep = {
		label = 'Transistep',
		type = 'transistep',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Livreur VL', payment = 50 },
			{ name = 'Livreur PL', payment = 75 },
			{ name = 'Livreur confirmé', payment = 100 },
			{ name = 'Chef d\'exploitation', payment = 125 },
			{ name = 'Co-patron', isboss = true, payment = 150 },
            { name = 'Patron', isboss = true, payment = 150 },
		},
	},

    unicorn = {
		label = 'Unicorn',
		type = 'unicorn',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Stagiaire', payment = 50 },
			{ name = 'Barman/maid', payment = 75 },
			{ name = 'Danseur/se', payment = 100 },
			{ name = 'Chef d\'équipe', payment = 125 },
			{ name = 'Co-Patron', isboss = true, payment = 150 },
            { name = 'Patron', isboss = true, payment = 150 },
		},
	},

    divin = {
		label = 'Divin',
		type = 'divin',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Barman intérimaire', payment = 50 },
			{ name = 'Barman', payment = 75 },
			{ name = 'Manager', payment = 100 },
			{ name = 'Co-Patron', isboss = true, payment = 125 },
			{ name = 'Patron', isboss = true, payment = 150 },
		},
	},

    blacktop = {
		label = 'The Black Top',
		type = 'blacktop',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Barman', payment = 50 },
			{ name = 'Serveur', payment = 75 },
			{ name = 'Chef d\'équipe', payment = 100 },
			{ name = 'Co-PDG', isboss = true, payment = 125 },
			{ name = 'PDG', isboss = true, payment = 150 },
		},
	},

    yellowjack = {
		label = 'Yellow Jack',
		type = 'yellowjack',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Agent de sécurité', payment = 50 },
			{ name = 'Serveur', payment = 75 },
			{ name = 'Barman', payment = 100 },
			{ name = 'Co-patron', isboss = true, payment = 125 },
			{ name = 'Patron', isboss = true, payment = 150 },
		},
	},

    salieris = {
		label = 'Bar Pisoni',
		type = 'salieris',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Sécurité', payment = 50 },
			{ name = 'Barman/maid', payment = 75 },
            { name = 'Chef d\'Equipe', payment = 75 },
			{ name = 'Co-Gérant', isboss = true, payment = 100 },
			{ name = 'Gérant ', isboss = true, payment = 125 },
		},
	},

    burgershot = {
		label = 'Burgershot',
		type = 'burgershot',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Stagiaire', payment = 50 },
			{ name = 'Employé libre-service', payment = 75 },
			{ name = 'Chef d\'équipe', payment = 100 },
			{ name = 'Co-Patron', payment = 125 },
			{ name = 'Patron', isboss = true, payment = 150 },
		},
	},

    pizzeria = {
		label = 'All\'Oro',
		type = 'pizzeria',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Employé', payment = 50 },
			{ name = 'Chef d\'équipe', payment = 75 },
			{ name = 'Responsable', payment = 100 },
			{ name = 'Co-PDG', isboss = true, payment = 125 },
			{ name = 'PDG', isboss = true, payment = 150 },
		},
	},

    chickndrive = {
		label = 'Chick\'n Drive',
		type = 'chickndrive',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Livreur', payment = 50 },
			{ name = 'Employé', payment = 75 },
			{ name = 'Chef d\'équipe', payment = 100 },
			{ name = 'DRH', payment = 125 },
			{ name = 'Co-PDG', isboss = true, payment = 150 },
            { name = 'PDG', isboss = true, payment = 150 },
		},
	},

    sandwichbar = {
		label = 'Chez Denis',
		type = 'sandwichbar',
		defaultDuty = false,
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
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Apprenti', payment = 50 },
			{ name = 'Tatoueur', payment = 75 },
			{ name = 'Manager', payment = 100 },
			{ name = 'Co-Patron', isboss = true, payment = 125 },
			{ name = 'Patron', isboss = true, payment = 150 },
		},
	},

    realestate = {
		label = 'Dynasty 9',
		type = 'realestate',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Agent Immobilier', payment = 150 },
            { name = 'DRH', payment = 150 },
            { name = 'Co-Patron', isboss = true, payment = 150 },
            { name = 'Patron', isboss = true, payment = 150 },
		},
	},

    barber = {
		label = 'Coiffeur',
		type = 'barber',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Stagiaire', payment = 50 },
			{ name = 'Apprenti', payment = 75 },
			{ name = 'Expérimenté', payment = 100 },
			{ name = 'Chef de salon', payment = 125 },
			{ name = 'Co-Patron', isboss = true, payment = 150 },
            { name = 'Patron', isboss = true, payment = 150 },
		},
	},

    taxi = {
		label = 'My Taxis',
		type = 'taxi',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Période d\'essai', payment = 50 },
			{ name = 'Taxi', payment = 75 },
			{ name = 'Chauffeur', payment = 100 },
			{ name = 'Patron', isboss = true, payment = 125 },
		},
	},

    security = {
		label = 'LS Security',
		type = 'security',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
            { name = 'Recrue', payment = 50 },
            { name = 'Agent de Sécurité', payment = 50 },
			{ name = 'Agent de Sécurité Confirmé', payment = 50 },
			{ name = 'Chef Sécurité', payment = 75 },
			{ name = 'Responsable', payment = 100 },
            { name = 'Co-Lead', isboss = true, payment = 125 },
			{ name = 'Lead', isboss = true, payment = 125 },
		},
	},

    youtool = {
		label = 'Youtool',
		type = 'youtool',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Décorateur', payment = 50 },
			{ name = 'Chauffeur livreur', payment = 75 },
			{ name = 'Vendeur', payment = 100 },
			{ name = 'Manager', payment = 125 },
			{ name = 'Co-Patron', isboss = true, payment = 150 },
            { name = 'Patron', isboss = true, payment = 150 },
		},
	},

    workshop = {
		label = 'Shutoko Workshop',
		type = 'workshop',
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Stagiaire', payment = 50 },
			{ name = 'Employé', payment = 75 },
			{ name = 'Chef d\'atelier', payment = 100 },
			{ name = 'Co-Patron', payment = 125 },
			{ name = 'Patron', isboss = true, payment = 150 },
		},
	},
--[[
    tabac = {
		label = 'Tabarico',
		type = 'tabac',
		defaultDuty = false,
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
		defaultDuty = false,
		offDutyPay = false,
		grades = {
			{ name = 'Recruit', payment = 50 },
			{ name = 'Novice', payment = 75 },
			{ name = 'Experienced', payment = 100 },
			{ name = 'Advanced', payment = 125 },
			{ name = 'Manager', isboss = true, payment = 150 },
		},
	},]]
}
