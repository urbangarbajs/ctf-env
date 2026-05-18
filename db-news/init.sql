SET NAMES utf8mb4;
SET time_zone = '+00:00';

CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE,
  slug VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE journalists (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL,
  beat VARCHAR(120) NOT NULL,
  bio TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE articles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT NOT NULL,
  journalist_id INT NOT NULL,
  title VARCHAR(220) NOT NULL,
  lead_text VARCHAR(500) NOT NULL,
  body TEXT NOT NULL,
  published_at DATETIME NOT NULL,
  breaking TINYINT(1) NOT NULL DEFAULT 0,
  FOREIGN KEY (category_id) REFERENCES categories(id),
  FOREIGN KEY (journalist_id) REFERENCES journalists(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  article_id INT NOT NULL,
  author_name VARCHAR(120) NOT NULL,
  body TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'pending',
  FOREIGN KEY (article_id) REFERENCES articles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(80) NOT NULL UNIQUE,
  full_name VARCHAR(160) NOT NULL,
  role VARCHAR(160) NOT NULL,
  email VARCHAR(180) NOT NULL,
  phone_extension VARCHAR(20),
  internal_flag VARCHAR(120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(80) NOT NULL UNIQUE,
  email VARCHAR(180) NOT NULL,
  password_hash CHAR(64) NOT NULL,
  password_hint VARCHAR(255) NOT NULL,
  role VARCHAR(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE business_documents (
  id INT AUTO_INCREMENT PRIMARY KEY,
  doc_title VARCHAR(220) NOT NULL,
  owner_department VARCHAR(120) NOT NULL,
  classification VARCHAR(80) NOT NULL,
  summary TEXT NOT NULL,
  fiscal_year INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE password_policy_notes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  account VARCHAR(80) NOT NULL,
  hash_type VARCHAR(80) NOT NULL,
  hashcat_mode VARCHAR(20) NOT NULL,
  password_length INT NOT NULL,
  pattern VARCHAR(255) NOT NULL,
  additional_hint VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO categories (name, slug) VALUES
('Slovenija','slovenija'),
('Svet','svet'),
('Politika','politika'),
('Gospodarstvo','gospodarstvo'),
('Kronika','kronika'),
('Šport','sport'),
('Kultura','kultura'),
('Tehnologija','tehnologija'),
('Vreme','vreme');

INSERT INTO journalists (name, email, beat, bio) VALUES
('Lara Vidmar','lara.vidmar@novapress.local','Slovenija','Terenska novinarka za lokalne skupnosti in javne storitve.'),
('Tadej Hribar','tadej.hribar@novapress.local','Svet','Urednik zunanjepolitičnih novic in evropskih tem.'),
('Nina Petek','nina.petek@novapress.local','Politika','Spremlja državni zbor, vlado in javne politike.'),
('Miha Rozman','miha.rozman@novapress.local','Gospodarstvo','Piše o podjetjih, delu in potrošniških trendih.'),
('Sara Kos','sara.kos@novapress.local','Kronika','Pokriva varnost, sodišča in intervencijske službe.'),
('Blaž Novak','blaz.novak@novapress.local','Šport','Športni poročevalec z mrežo dopisnikov po klubih.'),
('Eva Kranjc','eva.kranjc@novapress.local','Kultura','Spremlja knjige, gledališče, film in mestno kulturo.'),
('Jure Mehle','jure.mehle@novapress.local','Tehnologija','Raziskuje digitalne storitve, kibernetsko varnost in startupe.'),
('Tina Mlakar','tina.mlakar@novapress.local','Vreme','Vremenska urednica in koordinatorka napovedi.');

INSERT INTO articles (category_id, journalist_id, title, lead_text, body, published_at, breaking) VALUES
(1,1,'Jutranje zastoje v Ljubljani umirila dodatna avtobusna linija','Mestni promet poroča o hitrejšem pretoku na vpadnicah po uvedbi začasne linije.','Na območju severne obvoznice so vozniki zjutraj čakali manj kot v prejšnjih dneh. Mestna občina napoveduje, da bo podatke zbirala še dva tedna in nato odločila, ali linija ostane v voznem redu.', '2026-05-18 07:12:00',1),
(1,1,'Občine ob Savi usklajujejo načrt za protipoplavne nasipe','Župani treh občin so predstavili skupni projekt za varovanje naselij.','Projekt vključuje obnovo merilnih postaj, ureditev brežin in novo pot za intervencijska vozila. Dela naj bi se začela jeseni, če bo potrjena državna sofinanciranost.', '2026-05-14 16:30:00',0),
(1,1,'V Mariboru prenavljajo knjižnico v mestnem središču','Prenova bo trajala do konca poletja, izposoja bo medtem potekala v začasnih prostorih.','Mestna knjižnica uvaja premično izposojevališče in dodatne prevzemne točke. Uporabniki bodo lahko naročila oddali prek spleta ali telefona.', '2026-05-13 09:10:00',0),
(2,2,'Evropski ministri o skupnih energetskih rezervah','Na dnevnem redu so plin, električna omrežja in hitrejši postopki za čezmejne projekte.','Predlog predvideva boljše usklajevanje nakupov in izmenjavo podatkov o zalogah. Slovenija podpira rešitev, ki ne bi posegala v nacionalne varnostne rezerve.', '2026-05-18 08:44:00',1),
(2,2,'V Trstu odprli razstavo o jadranskih mestih','Razstava povezuje arhive iz Slovenije, Italije in Hrvaške.','Kustosi so izpostavili trgovske poti, pristaniško delo in zgodbe družin, ki so živele ob morju. Del programa je namenjen šolskim skupinam.', '2026-05-12 13:20:00',0),
(2,2,'Na Dunaju posvet o čezmejnih železniških povezavah','Strokovnjaki opozarjajo, da so vozni redi še vedno premalo usklajeni.','Razprava je poudarila predvsem povezave med alpskimi regijami in večjimi prestolnicami. Predstavniki prevoznikov obljubljajo pilotne sezonske povezave.', '2026-05-10 11:05:00',0),
(3,3,'Koalicija usklajuje spremembe zakona o javnih naročilih','Predlog naj bi poenostavil manjša naročila in okrepil nadzor nad večjimi projekti.','Opozicija opozarja, da so roki za obravnavo prekratki. Ministrstvo odgovarja, da je osnutek nastajal z občinami, podjetji in nadzornimi organi.', '2026-05-18 10:15:00',1),
(3,3,'Državni zbor potrjuje novo strategijo digitalnih storitev','V ospredju so varnost, dostopnost in manj administrativnih obrazcev.','Strategija predvideva enotne smernice za občinske portale, varnostne preglede in boljše obveščanje uporabnikov ob izpadih storitev.', '2026-05-13 14:50:00',0),
(3,3,'Predsedniki parlamentarnih odborov o delu po počitnicah','Jesenski koledar bo namenjen zdravstvu, stanovanjskim ukrepom in proračunu.','Vodje odborov napovedujejo več javnih predstavitev mnenj in gostov iz strokovnih organizacij. Prve seje bodo že v začetku septembra.', '2026-05-11 18:40:00',0),
(4,4,'Izvozniki pričakujejo previdno, a stabilno poletje','Naročila ostajajo zmerna, največ negotovosti je pri transportnih stroških.','Gospodarska zbornica vidi priložnost v nišnih izdelkih in večji avtomatizaciji. Podjetja medtem opozarjajo na pomanjkanje usposobljenih kadrov.', '2026-05-18 09:05:00',0),
(4,4,'Turistični ponudniki uvajajo skupno kartico za javni prevoz','Kartica bo obiskovalcem omogočila vožnjo z vlaki, avtobusi in izbranimi žičnicami.','Pilotni projekt se začne junija v treh regijah. Ponudniki pričakujejo manj avtomobilskega prometa v občutljivih dolinah.', '2026-05-14 12:00:00',0),
(4,4,'Trgovci poročajo o večjem zanimanju za lokalno hrano','Kupci pogosteje preverjajo poreklo izdelkov in sezonske oznake.','Analitiki trend povezujejo z večjo cenovno občutljivostjo in boljšim označevanjem na policah. Kmetijske zadruge pripravljajo dodatne dobave.', '2026-05-09 08:55:00',0),
(5,5,'Policija opozarja na lažna obvestila dostavnih služb','Prevaranti pošiljajo povezave za domnevno doplačilo poštnine.','Uporabnikom svetujejo, naj ne vpisujejo podatkov o karticah na povezavah iz sporočil. V primeru škode naj shranijo posnetke zaslona in obvestijo banko.', '2026-05-18 06:55:00',1),
(5,5,'Gasilci ponoči posredovali zaradi požara v skladišču','Poškodovanih ni bilo, preiskava vzroka še poteka.','Intervencija je trajala tri ure. Okoliškim prebivalcem so zaradi dima svetovali zapiranje oken, meritve zraka pa niso pokazale preseženih vrednosti.', '2026-05-14 07:45:00',0),
(5,5,'Sodišče obravnava primer spletne goljufije','Oškodovanci so denar nakazovali na račune v več državah.','Tožilstvo trdi, da je skupina uporabljala lažne prodajne profile in preusmerjala komunikacijo izven platform. Obramba očitke zanika.', '2026-05-12 10:25:00',0),
(6,6,'Košarkarji Olimpije začeli finalno serijo z zmago','Odločila je natančna igra v zadnjih petih minutah.','Trener je po tekmi pohvalil skok in obrambo na zunanji liniji. Naslednja tekma bo v petek zvečer.', '2026-05-18 05:50:00',0),
(6,6,'Kolesarska reprezentanca objavila seznam za poletne dirke','Na seznamu so izkušeni kapetani in trije mladi debitanti.','Selektor poudarja, da bodo vloge prilagajali profilu etap. Priprave se začnejo prihodnji teden na Primorskem.', '2026-05-13 15:35:00',0),
(6,6,'Nogometni derbi razprodan v manj kot uri','Organizatorji navijače pozivajo k pravočasnemu prihodu na stadion.','Zaradi povečanega obiska bo okrepljen javni prevoz. Policija napoveduje zapore v okolici stadiona dve uri pred tekmo.', '2026-05-11 09:45:00',0),
(7,7,'Festival dokumentarnega filma odpira zgodba o gorah','Program vključuje pogovore z avtorji in projekcije za dijake.','Organizatorji želijo letos več prostora nameniti domačim produkcijam. Vstopnice za večerni program so skoraj razprodane.', '2026-05-18 11:20:00',0),
(7,7,'V Celju gostuje razstava sodobne ilustracije','Mladi avtorji raziskujejo odnos med mestom, spominom in jezikom.','Razstava združuje plakate, knjige umetnika in animirane projekcije. Spremljevalni program vključuje delavnice za otroke.', '2026-05-12 16:10:00',0),
(7,7,'Knjižni sejem napoveduje več kot sto dogodkov','Založniki pričakujejo močan obisk šol in bralnih klubov.','Poseben poudarek bo na prevodni literaturi in literarnih podcastih. Sejem bo letos prvič delno prenašan tudi po spletu.', '2026-05-08 17:30:00',0),
(8,8,'Slovenski startup razvil senzor za pametne rastlinjake','Naprava meri vlago, temperaturo in hranila ter podatke pošilja v oblak.','Ekipa cilja predvsem na manjše pridelovalce, ki potrebujejo cenovno dostopen nadzor. Prve testne postavitve že delujejo v Pomurju.', '2026-05-18 12:05:00',0),
(8,8,'Strokovnjaki priporočajo posodobitev domačih usmerjevalnikov','Zastarela programska oprema je pogost vzrok za vdore v domača omrežja.','Uporabniki naj preverijo privzeta gesla, izklopijo nepotrebne storitve in omogočijo samodejne posodobitve, kjer je to mogoče.', '2026-05-14 18:05:00',0),
(8,8,'Univerze uvajajo skupno platformo za odprte podatke','Raziskovalci bodo lažje objavljali podatkovne zbirke in dokumentacijo.','Platforma podpira trajne identifikatorje, nadzor dostopa in povezovanje s projektno dokumentacijo. Prve zbirke bodo objavljene jeseni.', '2026-05-10 14:10:00',0),
(9,9,'Popoldne možne plohe, jutri sveže in vetrovno','Največ padavin pričakujejo v zahodni Sloveniji in ob hribovitih pregradah.','Vremenoslovci svetujejo spremljanje radarske slike pred potjo. Ob morju bo pihal zmeren jugozahodnik, zvečer se bo ozračje umirilo.', '2026-05-18 06:20:00',0),
(9,9,'Kmetje spremljajo sušno obdobje na severovzhodu','Namakanje bo ponekod potrebno prej kot običajno.','Agencija za okolje opozarja, da so razmere lokalno zelo različne. Več padavin je napovedanih za začetek prihodnjega tedna.', '2026-05-13 06:30:00',0);

INSERT INTO comments (article_id, author_name, body, created_at, status) VALUES
(1,'Matej','Končno nekaj premika pri avtobusih. Upam, da linija ostane.', '2026-05-15 08:01:00','approved'),
(1,'Nika','Zjutraj je bilo res manj čakanja na Celovški.', '2026-05-15 08:18:00','approved'),
(4,'Urban','Energetske rezerve so nujne, samo da ne bo spet več birokracije.', '2026-05-15 09:02:00','approved'),
(7,'Polona','Zakon naj bo pregleden, ne samo hitrejši.', '2026-05-15 11:31:00','pending'),
(8,'Iztok','Digitalne storitve morajo biti razumljive tudi starejšim.', '2026-05-13 16:05:00','approved'),
(10,'Nejc','Transport je letos največja uganka za manjša podjetja.', '2026-05-15 10:11:00','approved'),
(11,'Maja','Skupna kartica je odlična ideja za vikend izlete.', '2026-05-14 13:16:00','approved'),
(13,'Gregor','Tak SMS sem dobil včeraj. Povezava je izgledala sumljivo.', '2026-05-15 07:25:00','approved'),
(13,'Tina','Banke bi morale še bolj jasno opozarjati.', '2026-05-15 08:37:00','pending'),
(14,'Klara','Dobro, da ni bilo poškodovanih.', '2026-05-14 09:02:00','approved'),
(16,'Boris','Finale bo očitno zelo napet.', '2026-05-15 06:41:00','approved'),
(17,'Luka','Veseli me, da dobijo priložnost mladi kolesarji.', '2026-05-13 17:01:00','approved'),
(19,'Ana','Dokumentarni festival ima letos res močan program.', '2026-05-15 12:22:00','approved'),
(20,'Miha','Ilustracija v Celju je vedno vredna ogleda.', '2026-05-12 18:49:00','approved'),
(22,'Sara','Pametni rastlinjaki so zanimiva niša za Slovenijo.', '2026-05-15 12:46:00','approved'),
(23,'Uros','Posodobitev usmerjevalnika bi morala biti prvi korak po nakupu.', '2026-05-14 19:12:00','pending'),
(23,'Petra','Dobro opozorilo, veliko ljudi tega ne preveri nikoli.', '2026-05-14 19:28:00','approved'),
(25,'Vid','Radar kaže, da se plohe že razvijajo nad Notranjsko.', '2026-05-15 07:44:00','approved'),
(26,'Jasna','Na našem koncu je zemlja že precej suha.', '2026-05-13 07:08:00','approved'),
(5,'Alen','Lepo, da vključujejo tudi šolske skupine.', '2026-05-12 14:05:00','approved');

INSERT INTO employees (username, full_name, role, email, phone_extension, internal_flag) VALUES
('ana.zupan','Ana Zupan','odgovorna urednica','ana.zupan@novapress.local','101',NULL),
('matic.kovac','Matic Kovač','sistemski urednik','matic.kovac@novapress.local','213','NP-CTF{EMPLOYEE_DB_LEAK_2026}'),
('lara.vidmar','Lara Vidmar','novinarka','lara.vidmar@novapress.local','145',NULL),
('rok.pirc','Rok Pirc','oglasni oddelek','rok.pirc@novapress.local','177',NULL),
('tina.mlakar','Tina Mlakar','vremenska urednica','tina.mlakar@novapress.local','188',NULL);

INSERT INTO users (username, email, password_hash, password_hint, role) VALUES
('matic.kovac','matic.kovac@novapress.local','7fa5331351d857d9b522c9b52bcbc6fb4d1609ac9a66fd302a955b607ac66177','Rubrika portala + leto + klicaj','editor'),
('ana.zupan','ana.zupan@novapress.local','6f5e8c7d0bde45221f2e6a8f64f8a7e8d13bfa44b4e92ac2f1979d129e4da96e','Ni del laboratorijske poti','admin'),
('rok.pirc','rok.pirc@novapress.local','87df9f7d588d5bd0d4d7c9f89fb9b33c8dd5296010d6ecbd515e4f1b99cbb63b','Ni del laboratorijske poti','sales');

INSERT INTO business_documents (doc_title, owner_department, classification, summary, fiscal_year) VALUES
('Cenik oglasnih pasic Q2 2026','oglasni oddelek','interno','Načrt cen za domačo stran, kategorije, newsletter in sponzorirane članke.',2026),
('Dogovor o vremenskem podatkovnem viru','uredništvo vremena','interno','Opis prevzema vremenskih CSV datotek in odgovornosti za preverjanje napovedi.',2026),
('Načrt prenove naročniškega obrazca','produkt','zaupno','Opombe o poenostavitvi prijave na e-novice in merjenju konverzij.',2026),
('Seznam partnerskih radijskih postaj','poslovni razvoj','interno','Kontakti lokalnih postaj za jutranje novice in vremenske povzetke.',2026);

INSERT INTO password_policy_notes (account, hash_type, hashcat_mode, password_length, pattern, additional_hint) VALUES
('matic.kovac','SHA-256','1400',12,'Slovenska beseda z veliko začetnico + 2024 + !','Osnovna beseda je ena izmed glavnih rubrik portala.');
