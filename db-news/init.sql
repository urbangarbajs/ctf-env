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

CREATE TABLE portal_metadata (
  id INT AUTO_INCREMENT PRIMARY KEY,
  item_key VARCHAR(80) NOT NULL UNIQUE,
  item_value TEXT NOT NULL
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
('Ana Zupan','ana.zupan@novapress.local','Uredništvo','Odgovorna urednica za dnevni portal in notranji uredniški tok.'),
('Lara Vidmar','lara.vidmar@novapress.local','Slovenija','Terenska novinarka za lokalne skupnosti in javne storitve.'),
('Tadej Hribar','tadej.hribar@novapress.local','Svet','Urednik zunanjepolitičnih novic in evropskih tem.'),
('Nina Petek','nina.petek@novapress.local','Politika','Spremlja državni zbor, vlado in javne politike.'),
('Miha Rozman','miha.rozman@novapress.local','Gospodarstvo','Piše o podjetjih, delu in potrošniških trendih.'),
('Sara Kos','sara.kos@novapress.local','Kronika','Pokriva varnost, sodišča in intervencijske službe.'),
('Blaž Novak','blaz.novak@novapress.local','Šport','Športni poročevalec z mrežo dopisnikov po klubih.'),
('Eva Kranjc','eva.kranjc@novapress.local','Kultura','Spremlja knjige, gledališče, film in mestno kulturo.'),
('Tina Mlakar','tina.mlakar@novapress.local','Vreme','Vremenska urednica in koordinatorka napovedi.');

INSERT INTO articles (category_id, journalist_id, title, lead_text, body, published_at, breaking) VALUES
(1,2,'Jutranje zastoje v Ljubljani umirila dodatna avtobusna linija','Mestni promet poroča o hitrejšem pretoku na vpadnicah po uvedbi začasne linije.','Na območju severne obvoznice so vozniki zjutraj čakali manj kot v prejšnjih dneh. Mestna občina napoveduje, da bo podatke zbirala še dva tedna in nato odločila, ali linija ostane v voznem redu.', '2026-05-18 07:12:00',1),
(2,3,'Evropski ministri o skupnih energetskih rezervah','Na dnevnem redu so plin, električna omrežja in hitrejši postopki za čezmejne projekte.','Predlog predvideva boljše usklajevanje nakupov in izmenjavo podatkov o zalogah. Slovenija podpira rešitev, ki ne bi posegala v nacionalne varnostne rezerve.', '2026-05-18 08:44:00',1),
(3,4,'Koalicija usklajuje spremembe zakona o javnih naročilih','Predlog naj bi poenostavil manjša naročila in okrepil nadzor nad večjimi projekti.','Opozicija opozarja, da so roki za obravnavo prekratki. Ministrstvo odgovarja, da je osnutek nastajal z občinami, podjetji in nadzornimi organi.', '2026-05-18 10:15:00',1),
(4,5,'Izvozniki pričakujejo previdno, a stabilno poletje','Naročila ostajajo zmerna, največ negotovosti je pri transportnih stroških.','Gospodarska zbornica vidi priložnost v nišnih izdelkih in večji avtomatizaciji. Podjetja medtem opozarjajo na pomanjkanje usposobljenih kadrov.', '2026-05-18 09:05:00',0),
(5,6,'Policija opozarja na lažna obvestila dostavnih služb','Prevaranti pošiljajo povezave za domnevno doplačilo poštnine.','Uporabnikom svetujejo, naj ne vpisujejo podatkov o karticah na povezavah iz sporočil. V primeru škode naj shranijo posnetke zaslona in obvestijo banko.', '2026-05-18 06:55:00',0),
(6,7,'Košarkarji Olimpije začeli finalno serijo z zmago','Odločila je natančna igra v zadnjih petih minutah.','Trener je po tekmi pohvalil skok in obrambo na zunanji liniji. Naslednja tekma bo v petek zvečer.', '2026-05-18 05:50:00',0),
(7,8,'Festival dokumentarnega filma odpira zgodba o gorah','Program vključuje pogovore z avtorji in projekcije za dijake.','Organizatorji želijo letos več prostora nameniti domačim produkcijam. Vstopnice za večerni program so skoraj razprodane.', '2026-05-18 11:20:00',0),
(8,5,'Uredništva preizkušajo nove interne delovne tokove','Medijske hiše iščejo boljši nadzor nad osnutki, viri in pregledom pred objavo.','Nova orodja obljubljajo hitrejšo pripravo vsebin, vendar varnostni strokovnjaki opozarjajo, da morajo notranje storitve ostati ločene od javnega portala.', '2026-05-18 12:05:00',0),
(9,9,'Popoldne možne plohe, jutri sveže in vetrovno','Največ padavin pričakujejo v zahodni Sloveniji in ob hribovitih pregradah.','Vremenoslovci svetujejo spremljanje radarske slike pred potjo. Ob morju bo pihal zmeren jugozahodnik, zvečer se bo ozračje umirilo.', '2026-05-18 06:20:00',0),
(1,2,'Občine ob Savi usklajujejo načrt za protipoplavne nasipe','Župani treh občin so predstavili skupni projekt za varovanje naselij.','Projekt vključuje obnovo merilnih postaj, ureditev brežin in novo pot za intervencijska vozila. Dela naj bi se začela jeseni.', '2026-05-14 16:30:00',0),
(4,5,'Turistični ponudniki uvajajo skupno kartico za javni prevoz','Kartica bo obiskovalcem omogočila vožnjo z vlaki, avtobusi in izbranimi žičnicami.','Pilotni projekt se začne junija v treh regijah. Ponudniki pričakujejo manj avtomobilskega prometa v občutljivih dolinah.', '2026-05-14 12:00:00',0),
(8,5,'Strokovnjaki priporočajo posodobitev domačih usmerjevalnikov','Zastarela programska oprema je pogost vzrok za vdore v domača omrežja.','Uporabniki naj preverijo privzeta gesla, izklopijo nepotrebne storitve in omogočijo samodejne posodobitve, kjer je to mogoče.', '2026-05-14 18:05:00',0);

INSERT INTO comments (article_id, author_name, body, created_at, status) VALUES
(1,'Matej','Končno nekaj premika pri avtobusih. Upam, da linija ostane.', '2026-05-15 08:01:00','approved'),
(1,'Nika','Zjutraj je bilo res manj čakanja na Celovški.', '2026-05-15 08:18:00','approved'),
(8,'Polona','Notranja orodja so koristna, če so pravilno ločena od javnega dela.', '2026-05-15 11:31:00','approved'),
(9,'Vid','Radar kaže, da se plohe že razvijajo nad Notranjsko.', '2026-05-15 07:44:00','approved');

INSERT INTO portal_metadata (item_key, item_value) VALUES
('workflow_status','Pilotni uredniški tok je v pregledu pred javnim zagonom.'),
('weather_feed','Vremenski modul uporablja lokalno predpomnjenje in ročni uredniški pregled.');
