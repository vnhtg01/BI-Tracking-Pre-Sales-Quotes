DROP VIEW IF EXISTS public.suivi_devis;
CREATE OR REPLACE VIEW public.suivi_devis AS
SELECT 
    rc.id AS id_societe, -- ID de la société
    rc.name AS nom_societe, -- Nom de la société
    so.id AS id_devis, -- Identifiant du devis (clé primaire de sale_order)
    so.name AS nom_devis, -- Nom du devis
    rp.id AS id_client, -- ID du client (clé primaire de res_partner)
    rp.name AS nom_client, -- Nom du client (partenaire associé au devis)
	rp.street AS rue_adresse_client, -- Rue de l'adresse du client
    rp.street2 AS rue2_adresse_client, -- Deuxième ligne de rue (si présente) de l'adresse du client
    rp.city AS ville_client, -- Ville du client
    rp.zip AS code_postal_client, -- Code postal de l'adresse du client
    rps.id AS id_etat_client, -- ID de l'état (clé primaire de res_country_state)
    rps.name AS etat_client, -- État (province/région) du client
    rps_country.id AS id_pays_client, -- ID du pays (clé primaire de res_country)
    rps_country.name AS pays_client, -- Pays du client
    rp_responsible.id AS id_commercial, -- ID du commercial responsable du devis (clé primaire de res_partner)
    rp_responsible.name AS nom_commercial, -- Nom du commercial responsable du devis
    pt.id AS id_type_prestation, -- ID du modèle de produit (clé primaire de product_template)
    pt.name->>'fr_FR' AS nom_type_prestation, -- Type de prestation (nom du produit ou service)
    pp.id AS id_produit, -- ID du produit (clé primaire de product_product)
    pp.default_code AS code_produit, -- Code interne du produit (référence produit) dans la table product_product
    pt.name->>'fr_FR' AS nom_produit, -- Nom du produit depuis product_template
	sol.name AS description_ligne_devis, -- Description de la ligne du devis
    pc.id AS id_categorie_produit, -- ID de la catégorie (clé primaire de product_category)
    pc.name AS nom_categorie_produit, -- Catégorie du produit
	CASE 
        WHEN so.state = 'draft' THEN 'BRO' 
        WHEN so.state = 'sent' THEN 'ENV' 
        WHEN so.state = 'sale' THEN 'CONF' 
        WHEN so.state = 'done' THEN 'BLO' 
        WHEN so.state = 'cancel' THEN 'ANN' 
        ELSE 'INC' 
    END AS code_status_devis, -- Code Statut du devis
    CASE 
        WHEN so.state = 'draft' THEN 'Brouillon' 
        WHEN so.state = 'sent' THEN 'Envoyé' 
        WHEN so.state = 'sale' THEN 'Confirmé' 
        WHEN so.state = 'done' THEN 'Bloqué' 
        WHEN so.state = 'cancel' THEN 'Annulé' 
        ELSE 'Inconnu' 
    END AS libelle_status_devis, -- Libellé Statut du devis
	so.create_date AS date_creation, -- Date de création du devis
    so.date_order AS date_validation, -- Date de validation du devis (confirmée en tant que commande)
    sol.price_subtotal AS montant_ht, -- Montant HT (hors taxes) des lignes de devis
    sol.price_total AS montant_ttc -- Montant TTC (toutes taxes comprises) des lignes de devis
FROM 
    sale_order AS so -- Table contenant les devis
INNER JOIN 
    res_company AS rc ON so.company_id = rc.id -- Table des sociétés pour récupérer le nom de la société
LEFT JOIN 
    res_partner AS rp ON so.partner_id = rp.id -- Table des partenaires (clients), lien avec le client
LEFT JOIN 
    res_users AS u_responsible ON so.user_id = u_responsible.id -- Table des utilisateurs (commerciaux), lien avec le commercial responsable
LEFT JOIN 
    res_partner AS rp_responsible ON u_responsible.partner_id = rp_responsible.id -- Table des partenaires associés à des utilisateurs, pour obtenir le nom du commercial
LEFT JOIN 
    sale_order_line AS sol ON so.id = sol.order_id -- Table des lignes de devis (chaque ligne représente un produit ou service du devis)
LEFT JOIN 
    product_product AS pp ON sol.product_id = pp.id -- Table des produits spécifiques, pour obtenir les détails du produit
LEFT JOIN 
    product_template AS pt ON pp.product_tmpl_id = pt.id -- Table des templates de produits, pour récupérer le modèle de produit
LEFT JOIN 
    product_category AS pc ON pt.categ_id = pc.id -- Table des catégories de produits, pour récupérer la catégorie du produit
LEFT JOIN 
    res_country_state AS rps ON rp.state_id = rps.id -- Table des états/provinces, pour récupérer l'état/province du client
LEFT JOIN 
    res_country AS rps_country ON rp.country_id = rps_country.id -- Table des pays, pour récupérer le pays du client
WHERE 
    so.state IN ('draft', 'sent', 'sale', 'done', 'cancel') -- Filtre pour inclure les devis ayant un état parmi ceux spécifiés
    AND rc.name = 'IT4Logs'
	and so.create_date::date >= '2025-03-02'
ORDER BY 
    so.create_date DESC;
