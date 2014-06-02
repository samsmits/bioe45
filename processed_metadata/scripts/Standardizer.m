%% Get input file
%   This script converts the ELDERMET data into the standard form as
%   defined by the group and outputs a .csv file.
%   
%   The columns are as follows: (* used in this study) (x need to be added)
        % 1   x*Study
        % 2   1*Sample Identifier
        % 3   2*Age
        % 4   4*Stratum
        % 5     Family ID
        % 6     Family Member
        % 7     Zygosity
        % 8    *Location
        % 9  10*Weight
        % 10 11*BMI
        % 11   *Race
        % 12  3*Sex
        % 13  x*Species
        % 14	Breast-fed
        % 15	Exercise Frequency
        % 16	Dog?
        % 17	Cat?
        % 18	Smoking Frequency
        % 19	Sleep
        % 20	Multivitamin
        % 21 12*Calf Circumference
        % 22 14*Systolic Blood Pressure
        % 23 13*Diastolic Blood Pressure
        % 24  8*Barthel Index of Activities of Daily Living
        % 25  7*Functional Independence Measure
        % 26  9*Mini-Mental State Exam
        % 27 16*Mini-Nutrition Assessment
        % 28 15*Geriatric Depression Test
        % 29  6*Charlson Index of Comorbidity
        % 30    Percent of Carbohydrates from Processed Carbohydrates
        % 31    Lactose Intolerant
        % 32	# Plants Consumes
        % 33	Primary Carb
        % 34	Primary Vegetable
        % 35  22*Energy (kcal)
        % 36  24*Total Fat (g)
        % 37  26*Total Carbohydrate (g)
        % 38  23*Total Protein (g)
        % 39	Animal Protein (g)
        % 40	Vegetable Protein (g)
        % 41	Alcohol (g)
        % 42	Alcohol (frequency)
        % 43  66*Cholesterol (mg)
        % 44  63*Total Saturated Fatty Acids (SFA) (g)
        % 45  64*Total Monounsaturated Fatty Acids (MUFA) (g)
        % 46  65*Total Polyunsaturated Fatty Acids (PUFA) (g)
        % 47	Fructose (g)
        % 48	Galactose (g)
        % 49	Glucose (g)
        % 50	Lactose (g)
        % 51	Maltose (g)
        % 52	Sucrose (g)
        % 53	Starch (g)
        % 54  27*Total Dietary Fiber (g)
        % 55	Soluble Dietary Fiber (g)
        % 56	Insoluble Dietary Fiber (g)
        % 57	Pectins (g)
        % 58   51*Total Vitamin A Activity (International Units) (IU)
        % 59    Beta-Carotene Equivalents (derived from provitamin A carotenoids) (mcg)
        % 60   53*Retinol (mcg)
        % 61   60*Vitamin D (calciferol) (mcg)
        % 62	Total Alpha-Tocopherol Equivalents (mg)
        % 63   59*Vitamin E (Total Alpha-Tocopherol) (mg)
        % 64	Beta-Tocopherol (mg)
        % 65	Gamma-Tocopherol (mg)
        % 66	Delta-Tocopherol (mg)
        % 67  62*Vitamin K (phylloquinone) (mcg)
        % 68  39*Vitamin C (ascorbic acid) (mg)
        % 69  40*Thiamin (vitamin B1) (mg)
        % 70  41*Riboflavin (vitamin B2) (mg)
        % 71  42*Niacin (vitamin B3) (mg)
        % 72  43*Pantothenic Acid (mg)
        % 73  44*Vitamin B-6 (pyridoxine. pyridoxyl. and pyridoxamine) (mg)
        % 74  45*Total Folate (mcg)
        % 75  50*Vitamin B-12 (cobalamin) (mcg)
        % 76  29*Calcium (mg)
        % 77  32*Phosphorus (mg)
        % 78  31*Magnesium (mg)
        % 79  30*Iron (mg)
        % 80  35*Zinc (mg)
        % 81  36*Copper (mg)
        % 82  38*Selenium (mcg)
        % 83  34*Sodium (mg)
        % 84  33*Potassium (mg)
        % 85	SFA 4:0 (butyric acid) (g)
        % 86	SFA 6:0 (caproic acid) (g)
        % 87	SFA 8:0 (caprylic acid) (g)
        % 88	SFA 10:0 (capric acid) (g)
        % 89	SFA 12:0 (lauric acid) (g)
        % 90	SFA 14:0 (myristic acid) (g)
        % 91	SFA 16:0 (palmitic acid) (g)
        % 92	SFA 17:0 (margaric acid) (g)
        % 93	SFA 18:0 (stearic acid) (g)
        % 94	SFA 20:0 (arachidic acid) (g)
        % 95	SFA 22:0 (behenic acid) (g)
        % 96	MUFA 14:1 (myristoleic acid) (g)
        % 97	MUFA 16:1 (palmitoleic acid) (g)
        % 98	MUFA 18:1 (oleic acid) (g)
        % 99	MUFA 20:1 (gadoleic acid) (g)
        % 100	MUFA 22:1 (erucic acid) (g)
        % 101	PUFA 18:2 (linoleic acid) (g)
        % 102	PUFA 18:3 (linolenic acid) (g)
        % 103	PUFA 18:4 (parinaric acid) (g)
        % 104	PUFA 20:4 (arachidonic acid) (g)
        % 105	PUFA 20:5 (eicosapentaenoic acid [EPA]) (g)
        % 106	PUFA 22:5 (docosapentaenoic acid [DPA]) (g)
        % 107	PUFA 22:6 (docosahexaenoic acid [DHA]) (g)
        % 108	Tryptophan (g)
        % 109	Threonine (g)
        % 110	Isoleucine (g)
        % 111	Leucine (g)
        % 112	Lysine (g)
        % 113	Methionine (g)
        % 114	Cystine (g)
        % 115	Phenylalanine (g)
        % 116	Tyrosine (g)
        % 117	Valine (g)
        % 118	Arginine (g)
        % 119	Histidine (g)
        % 120	Alanine (g)
        % 121	Aspartic Acid (g)
        % 122	Glutamic Acid (g)
        % 123	Glycine (g)
        % 124	Proline (g)
        % 125	Serine (g)
        % 126	Aspartame (mg)
        % 127	Caffeine (mg)
        % 128	Phytic Acid (mg)
        % 129	Oxalic Acid (mg)
        % 130	3-Methylhistidine (mg)
        % 131 25*Ash (g)
        % 132 21*Water (g)
        % 133	% Calories from Fat
        % 134	% Calories from Carbohydrate
        % 135	% Calories from Protein
        % 136	% Protein from Animal Protein
        % 137	% Protein from Plant Protein
        % 138	% Calories from Alcohol
        % 139	% Calories from SFA
        % 140	% Calories from MUFA
        % 141	% Calories from PUFA
        % 142	Polyunsaturated to Saturated Fat Ratio
        % 143	Cholesterol to Saturated Fatty Acid Index
        % 144  52*Total Vitamin A Activity (Retinol Equivalents) (mcg)
        % 145	TRANS 18:1 (trans-octadecenoic acid [elaidic acid]) (g)
        % 146	TRANS 18:2 (trans-octadecadienoic acid [linolelaidic acid]; incl. c-t. t-c. t-t) (g)
        % 147	TRANS 16:1 (trans-hexadecenoic acid) (g)
        % 148	Total Trans-Fatty Acids (TRANS) (g)
        % 149  55*Beta-Carotene (provitamin A carotenoid) (mcg)
        % 150  54*Alpha-Carotene (provitamin A carotenoid) (mcg)
        % 151  56*Beta-Cryptoxanthin (provitamin A carotenoid) (mcg)
        % 152  58*Lutein + Zeaxanthin (mcg)
        % 153  57*Lycopene (mcg)
        % 154  48*Dietary Folate Equivalents (mcg)
        % 155  47*Natural Folate (food folate) (mcg)
        % 156  46*Synthetic Folate (folic acid) (mcg)
        % 157	Total Vitamin A Activity (Retinol Activity Equivalents) (mcg)
        % 158	Niacin Equivalents (mg)
        % 159  28*Total Sugars (g)
        % 160	Omega-3 Fatty Acids (g)
        % 161  37*Manganese (mg)re
        % 162	Vitamin E (International Units) (IU)
        % 163	Natural Alpha-Tocopherol (RRR-alpha-tocopherol or d-alpha-tocopherol) (mg)
        % 164	Synthetic Alpha-Tocopherol (all rac-alpha-tocopherol or dl-alpha-tocopherol) (mg)
        % 165	Daidzein (mg)
        % 166	Genistein (mg)
        % 167	Glycitein (mg)
        % 168	Coumestrol (mg)
        % 169	Biochanin A (mg)
        % 170	Formononetin (mg)
        % 171	Added Sugars (g)
        % 172	Acesulfame Potassium (mg)
        % 173	Sucralose (mg)
        % 174	Available Carbohydrate (g)
        % 175	Glycemic Index (glucose reference)
        % 176	Glycemic Index (bread reference)
        % 177	Glycemic Load (glucose reference)
        % 178	Glycemic Load (bread reference)
        % 179 49*Choline (mg)
        % 180	Betaine (mg)
        % 181	Erythritol (g)
        % 182	Inositol (g)
        % 183	Mannitol (g)
        % 184	Pinitol (g)
        % 185	Sorbitol (g)
        % 186	Xylitol (g)
        % 187	Nitrogen (g)
        % 188	Total Conjugated Linoleic Acid (CLA 18:2) (g)
        % 189	CLA cis-9. trans-11 (g)
        % 190	CLA trans-10. cis-12 (g)
        % 191	Tagatose (mg)
        % 192	Antibiotic history
        % 193	Bowel movement frequency
        % 194	Last Traveled
        % 195	Beesting Allergy
        % 196	Run Date
        % 197	Drug Allergies
        % 198	Sample Mass
        % 199	General Meds
        % 200	Body Site of Sample
        % 201	Migraine Factor 1
        % 202	Migraine Factor 2
        % 203	Migraine Factor 3
        % 204	Tonsils Removed
        % 205	Elevation
        % 206	Pet Location
        % 207	Flossing Frequency
        % 208	C-Section
        % 209	Country of Birth
        % 210	Macronutrient Percent Total
        % 211	Cosmetics Frequency
        % 212	Mastermix Lot
        % 213	Host Subject ID
        % 214	Gluten Intolerant
        % 215	TM_1000_8_tool
        % 216	Longitude
        % 217	Pet Contact
        % 218	Migraine Aggravation
        % 219	Diabetes Medication
        % 220	Sample Plate
        % 221	Panicillin
        % 222	Key Sequence
        % 223	Body Product
        % 224	Region
        % 225	Migraine Frequency
        % 226	Pregnant
        % 227	Migraine Relatives
        % 228	Extraction Kit Lot
        % 229	Sample
        % 230	Migraine Photophobia
        % 231	Site Sampled
        % 232	Current Residence Duration
        % 233	Antibiotic Select
        % 234	Migraine Nausea
        % 235	Common Name
        % 236	Treenut Allergies
        % 237	Migraine Aura
        % 238	Target Gene
        % 239	Sequencing Method
        % 240	Flu Vaccine Date
        % 241	PCR Primers
        % 242	Migraine
        % 243	Environmental Biome
        % 244	Well ID
        % 245	Teethbrushing Frequency
        % 246	Nitromidazole
        % 247	Migraine Medications
        % 248	Contraceptive
        % 249	Sample Center
        % 250	Living With
        % 251	Diabetes Medication
        % 252	Library Construction Protocol
        % 253	Description Duplicate
        % 254	Tanning Sprays
        % 255	Birth Date
        % 256	Extraction Robot
        % 257	Sulfa Drug
        % 258	Non-food Allergies - NO
        % 259	Environment Matter
        % 260	Skin Condition
        % 261	Dander Allergy
        % 262	Conditions Medication
        % 263	Acne Medication
        % 264	Target Subfragment
        % 265	Title
        % 266	Height In
        % 267	Antibiotic Condition
        % 268	Host Common Name
        % 269	Migraine Pain
        % 270	Roommates
        % 271	Primer Plate
        % 272	Sun Allergies
        % 273	Exercise Location
        % 274	TM50_8 Tool
        % 275	Collection Date
        % 276	Altitude
        % 277	Shellfish Allergy
        % 278	Quinoline
        % 279	Shared Housing
        % 280	Pregnant Due Date
        % 281	Anonymized Name
        % 282	Softener
        % 283	Migraine Phonophobia
        % 284	Sample Description
        % 285	Sample Size
        % 286	Supplements
        % 287	Poison Ivy Allergy
        % 288	Tanning Beds
        % 289	Deceased Parent
        % 290	Study Center
        % 291	Body Habitat
        % 292	Dominant Hand
        % 293	Diabetes Diagnosis Date
        % 294	Special Restrictions
        % 295	Cephalosporin
        % 296	Environmental Feature
        % 297	Supplement Fields
        % 298	Sample Time
        % 299	Appendix Removed
        % 300	Drinking Water Source
        % 301	Communal Dining
        % 302	Diet Type
        % 303	Run Center
        % 304	Diet Restrictions
        % 305	Experiment Center
        % 306	Height or Length
        % 307	Antibiotic Meds
        % 308	IBD/IBS
        % 309	Depth
        % 310	Processing Robot
        % 311	Host Taxid
        % 312	Migraine Meds
        % 313	Taxon ID
        % 314	Main Factor - Other 3
        % 315	Plating
        % 316	Main Factor - Other 1
        % 317	Nails
        % 318	Run Prefix
        % 319	Platform
        % 320	Deodorant Use
        % 321	Pets
        % 322	Main Factor - Other 2
        % 323	Acne Medication OTC
        % 324	Machine
        % 325	Study ID
        % 326	TM300_8 Tool
        % 327	Food Allergies - Other Text
        % 328	Experiment Design Description
        % 329	Food Allergies - Other
        % 330	Weight Change
        % 331	Primer Date
        % 332	Diabetes
        % 333	Asthma
        % 334	Pool Frequency
        % 335	PKU
        % 336	Frat
        % 337	Latitude
        % 338	Peanut Allergies
        % 339	Chickenpox
        % 340	Seasonal Allergies
        % 341	Description
        % 342	Country
        % 343	State
        % 344	City
        % 345	Zip Code
        % 346	Race (Other)

%% Read in file

dataFile = 'ELDERMET_diets.csv';
headerFile = 'fields.csv';
outputFile = 'ELDERMET_standardized.csv';

rawdata = importdata(dataFile,',');
head = importdata(headerFile,',',1);

%% Match headers from ELDERMET data to 

header = strsplit(head{1},',');
ELDERMAThead = rawdata.textdata(1,:);
ELDERMAThead(15:20) = [];
ELDERMAThead(5) = [];

% Matched headers will be placed in an index
index = zeros(1,length(header));
k = 0;

for i = 1:numel(ELDERMAThead);
    for j=1:numel(header);
        header{j};
        ELDERMAThead{i};
        if strcmp(header{j}, ELDERMAThead{i});
            index(j) = i;
            disp(ELDERMAThead{i});
            k = k+1;
        end
    end
end

index(1) = [99];    % special case

%% Make cvs file

study = {'ELDERMET'};
nrows = length(rawdata.data);
cellDat = {repmat(study, nrows,1)};


numDat = rawdata.data;
textDat = rawdata.textdata(1:end,1:4);
numDat(:,11:16)=[];
numDat(:,1) = [];

% Write headers to file
fid = fopen(outputFile,'w');
for n = 1:length(header);
    fprintf(fid,'%s',header{n});
    if n ~=length(header)
        fprintf(fid,'%s',',');
    else
        fprintf(fid,'\n');
    end
end


% Write the data   
for j = 1:nrows;
    for i = 1:numel(index);
        
        colnum = index(i);  
        
        % if the first element in the row, always add the study name
        if colnum == 99;
            fprintf(fid,'ELDERMET');
      
        % if colnum is zero, there is no data for that field
        elseif colnum == 0;
            fprintf(fid,' ');
        
        % data from numeric portion of data
        elseif colnum >4;
            el = numDat(j,colnum-4);
            if isnan(el);               % if NaN, will print empty
                fprintf(fid,' ');
            else
                fprintf(fid,'%f',el);
            end
        
        % data from text portion of data
        elseif colnum <=4
            if colnum == 2;
                el = textDat{j+1,colnum};
                fprintf(fid,'%s',el);
            else
                el = textDat{j+1,colnum};
                fprintf(fid,'%s',el);
            end
        end
        
        % write a comma if not the end of the line, \n if end of line
        if i ~=numel(index)
            fprintf(fid,'%s',',');
        else
            fprintf(fid,'\n');
        end
    end
end
fclose(fid)  %ALWAYS CLOSE THE FILE! (I found out the hard way)






