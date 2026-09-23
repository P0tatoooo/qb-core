QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
-- Statut automatique (l'entreprise ouvre à la prise de service, et ne ferme pas
-- tant qu'un employé est en service) : la liste était ici, elle est maintenant
-- la colonne `autostatus` de la table `jobs`, réglable depuis MyCity_AdminMenu
-- (Entreprises). Elle se lit sur le métier — QBCore.Shared.Jobs[job].autostatus
-- — ou, depuis une autre ressource, par exports['qb-core']:IsJobAutoStatus(job).

QBShared.Jobs = {
}
