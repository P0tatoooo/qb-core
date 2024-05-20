QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
QBShared.QBJobsStatus = false -- true: integrate qb-jobs into the whole of qb-core | false: treat qb-jobs as an add-on resource.
QBShared.Jobs = {} -- All of below has been migrated into qb-jobs
if QBShared.QBJobsStatus then return end
QBShared.Jobs = {
	['unemployed'] = {
		label = 'Sans Emploi',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Chômeur',
                payment = 10
            },
        },
	},
	['police'] = {
		label = 'Law Enforcement',
        type = "leo",
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Officer',
                payment = 75
            },
			['2'] = {
                name = 'Sergeant',
                payment = 100
            },
			['3'] = {
                name = 'Lieutenant',
                payment = 125
            },
			['4'] = {
                name = 'Chief',
				isboss = true,
                payment = 150
            },
            ['5'] = {
                name = 'Chief',
				isboss = true,
                payment = 150
            },
            ['6'] = {
                name = 'Chief',
				isboss = true,
                payment = 150
            },
            ['7'] = {
                name = 'Chief',
				isboss = true,
                payment = 150
            },
            ['8'] = {
                name = 'Chief',
				isboss = true,
                payment = 150
            },
            ['9'] = {
                name = 'Chief',
				isboss = true,
                payment = 150
            },
            ['10'] = {
                name = 'Chief',
				isboss = true,
                payment = 150
            },
        },
	},
	['ambulance'] = {
		label = 'EMS',
        type = 'ems',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Paramedic',
                payment = 75
            },
			['2'] = {
                name = 'Doctor',
                payment = 100
            },
			['3'] = {
                name = 'Surgeon',
                payment = 125
            },
			['4'] = {
                name = 'Chief',
				isboss = true,
                payment = 150
            },
        },
	},
	['realestate'] = {
		label = 'Immobilier',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'House Sales',
                payment = 75
            },
			['2'] = {
                name = 'Business Sales',
                payment = 100
            },
			['3'] = {
                name = 'Broker',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},
	['taxi'] = {
		label = 'Taxi',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Driver',
                payment = 75
            },
			['2'] = {
                name = 'Event Driver',
                payment = 100
            },
			['3'] = {
                name = 'Sales',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},
    ['bus'] = {
		label = 'Bus',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Driver',
                payment = 50
            },
		},
	},
	['cardealer'] = {
		label = 'Vehicle Dealer',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Showroom Sales',
                payment = 75
            },
			['2'] = {
                name = 'Business Sales',
                payment = 100
            },
			['3'] = {
                name = 'Finance',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},
	['mechanic'] = {
		label = 'Mechanic',
        type = "mechanic",
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Novice',
                payment = 75
            },
			['2'] = {
                name = 'Experienced',
                payment = 100
            },
			['3'] = {
                name = 'Advanced',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},
	['judge'] = {
		label = 'Honorary',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Judge',
                payment = 100
            },
        },
	},
	['lawyer'] = {
		label = 'Law Firm',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Associate',
                payment = 50
            },
        },
	},
	['reporter'] = {
		label = 'Reporter',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Journalist',
                payment = 50
            },
        },
	},
	['trucker'] = {
		label = 'Trucker',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Driver',
                payment = 50
            },
        },
	},
	['tow'] = {
		label = 'Towing',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Driver',
                payment = 50
            },
        },
	},
	['garbage'] = {
		label = 'Garbage',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Collector',
                payment = 50
            },
        },
	},
	['hotdog'] = {
		label = 'Hotdog',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Sales',
                payment = 50
            },
        },
	},
    ['farmer'] = {
		label = 'Agriculteur',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['bahamas'] = {
		label = 'Bahamas',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['barber'] = {
		label = 'Coiffeur',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['bikedealer'] = {
		label = 'Concess Moto',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['burgershot'] = {
		label = 'Burgershot',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['casino'] = {
		label = 'Casino',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['club'] = {
		label = 'Club Medellin',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['concessoccasion'] = {
		label = 'Concess Occasion',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['diner'] = {
		label = 'Diner',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['divin'] = {
		label = 'Divin',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['drift'] = {
		label = 'Drift',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['flightschool'] = {
		label = 'Ecole de Pilotage',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['government'] = {
		label = 'Gouvernement',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['grandemotors'] = {
		label = 'Grande Motors',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['henhouse'] = {
		label = 'Hen House',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['ikea'] = {
		label = 'IKEA',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['mcevent'] = {
		label = 'MC Event',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['mcnews'] = {
		label = 'MC News',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['mechanicmoto'] = {
		label = 'Moto',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['mexicanbar'] = {
		label = 'Mexican Bar',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['musiclabel'] = {
		label = 'Label Musique',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['petstore'] = {
		label = 'Animalerie',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['prospector'] = {
		label = 'Mineur',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['ranch'] = {
		label = 'Ranch',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['refinery'] = {
		label = 'Petrolium',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['sakura'] = {
		label = 'Sakura',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['security'] = {
		label = 'Securité',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['shishabar'] = {
		label = 'Bar à Chicha',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['tabac'] = {
		label = 'Tabac',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['tattooshop'] = {
		label = 'Tatoueur',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['tequilala'] = {
		label = 'Tequilala',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['transistep'] = {
		label = 'Transistep',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['unicorn'] = {
		label = 'Unicorn',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
    ['vineyard'] = {
		label = 'Vignoble',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Boss',
                isboss = true,
                payment = 50
            },
		},
	},
}
