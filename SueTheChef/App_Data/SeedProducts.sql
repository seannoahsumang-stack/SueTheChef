/*
  Keep Rollin Co — seed PRODUCTS for Shop / Details / Cart.
  Run once in SSMS against your database (e.g. S26Team12).

  Re-run safe: deletes only these rows by ProductName, then re-inserts.
*/
SET NOCOUNT ON;

DELETE FROM dbo.PRODUCTS
WHERE ProductName IN (
    N'Michelin Pilot Sport 4S',
    N'Continental ExtremeContact DWS06 Plus',
    N'Bridgestone Blizzak WS90',
    N'Goodyear Eagle F1 Asymmetric 6',
    N'Falken Azenis FK510',
    N'Enkei RPF1 Alloy',
    N'Volk Racing TE37SL',
    N'Rotiform LAS-R',
    N'Konig Ampliform',
    N'Method MR305 NV',
    N'Yokohama ADVAN Apex V601',
    N'BBS CH-R'
);

INSERT INTO dbo.PRODUCTS (ProductName, ProductType, Price, Description, Specs, ImageURL) VALUES
(N'Michelin Pilot Sport 4S', N'Tire', 229.99,
 N'Ultra-high-performance summer tire; strong wet grip and steering response.',
 N'225/45R17', N'~/Images/products/michelin-pilot-sport-4s.jpg'),

(N'Continental ExtremeContact DWS06 Plus', N'Tire', 199.50,
 N'All-season UHP tire with balanced wet/dry performance.',
 N'245/40R18', N'~/Images/products/continental-dws06-plus.jpg'),

(N'Bridgestone Blizzak WS90', N'Tire', 168.00,
 N'Studless winter tire for cold climates and snow traction.',
 N'215/55R17', N'~/Images/products/bridgestone-blizzak-ws90.jpg'),

(N'Goodyear Eagle F1 Asymmetric 6', N'Tire', 214.75,
 N'Performance touring tire; quiet ride with confident cornering.',
 N'255/35R19', N'~/Images/products/goodyear-eagle-f1-asymmetric-6.jpg'),

(N'Falken Azenis FK510', N'Tire', 159.99,
 N'Value-focused UHP summer compound for spirited street driving.',
 N'225/50R17', N'~/Images/products/falken-azenis-fk510.jpg'),

(N'Enkei RPF1 Alloy', N'Wheel', 349.00,
 N'Lightweight motorsport-inspired 6-spoke; track-day friendly.',
 N'18x8 ET35 5x114.3', N'~/Images/products/enkei-rpf1-alloy.jpg'),

(N'Volk Racing TE37SL', N'Wheel', 599.00,
 N'Forged monoblock; high strength-to-weight for serious use.',
 N'18x9.5 ET22 5x120', N'~/Images/products/volk-racing-te37sl.jpg'),

(N'Rotiform LAS-R', N'Wheel', 279.50,
 N'Cast multi-spoke street wheel; deep concave profile.',
 N'19x8.5 ET35 5x112', N'~/Images/products/rotiform-las-r.jpg'),

(N'Konig Ampliform', N'Wheel', 219.00,
 N'Flow-formed; good brake clearance for many chassis.',
 N'17x8 ET45 5x100', N'~/Images/products/konig-ampliform.jpg'),

(N'Method MR305 NV', N'Wheel', 189.99,
 N'Tough truck/SUV style; matte finish.',
 N'17x8.5 ET0 6x139.7', N'~/Images/products/method-mr305-nv.jpg'),

(N'Yokohama ADVAN Apex V601', N'Tire', 189.25,
 N'Warm-weather performance tire with stable shoulder blocks.',
 N'245/45R18', N'~/Images/products/yokohama-advan-apex-v601.jpg'),

(N'BBS CH-R', N'Wheel', 449.00,
 N'Classic mesh Y-spoke; OE+ appearance.',
 N'18x8 ET40 5x112', N'~/Images/products/bbs-ch-r.jpg');

PRINT CAST(@@ROWCOUNT AS varchar(10)) + N' product row(s) inserted.';
