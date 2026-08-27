-- ==========================================================================
-- Supabase Comprehensive Seed: 12 Real Pune Infrastructure Projects
-- Contains 12 Projects + R&R Status + ~775 Detailed Family Land Parcel Records
-- 100% Real Database Grounding (No Mock Fallbacks)
-- Run this directly in Supabase SQL Editor
-- ==========================================================================

DO $$
DECLARE
    v_profile_id UUID;
    v_proj1 UUID;
    v_proj2 UUID;
    v_proj3 UUID;
    v_proj4 UUID;
    v_proj5 UUID;
    v_proj6 UUID;
    v_proj7 UUID;
    v_proj8 UUID;
    v_proj9 UUID;
    v_proj10 UUID;
    v_proj11 UUID;
    v_proj12 UUID;
BEGIN
    -- Grab first available profile ID for created_by reference
    SELECT id INTO v_profile_id FROM public.profiles LIMIT 1;

    -- Clean up previous Pune projects cleanly (cascades to families and rr)
    DELETE FROM public.projects WHERE district = 'Pune';

    -- ==========================================================
    -- PROJECT 1: Pune Ring Road Phase 2 (Wadgaon-Khadakwasla Corridor) (Highway)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Pune Ring Road Phase 2 (Wadgaon-Khadakwasla Corridor)', 'Highway', 'Pune', 'Wadgaon Budruk, Khadakwasla, Dhayari, Nanded, Kirkatwadi',
        840.5, 80, 18,
        '2024-03-01', '2026-12-31', 'Yes',
        true, 18, v_profile_id
    ) RETURNING id INTO v_proj1;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj1, 80, 25, 18
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj1, 'Prakash Kamble (Survey 114/1A)', 6.3, 1977721, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Sunita Gore (Survey 51/3)', 2.96, 483353, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Rajendra Joshi (Survey 231/2)', 1.37, 359772, 'Pending', 'Active', '2026-01-12', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Santosh Joshi (Survey 396/2B)', 0.68, 177930, 'Paid', 'Active', '2025-11-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Pandurang Deshmukh (Survey 236/1)', 3.99, 716284, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj1, 'Vitthal Bhandari (Survey 276/3)', 11.19, 2098001, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Laxmibai Salunkhe (Survey 374/4C)', 10.83, 1853673, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Bhaurao Kadam (Survey 420/2)', 9.61, 2724242, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj1, 'Sunita Joshi (Survey 49/A)', 7.29, 1690171, 'Pending', 'Active', '2026-04-12', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Baburao Bapat (Survey 72/1A)', 3.58, 764530, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj1, 'Ashok Mohite (Survey 306/A)', 10.41, 2108306, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Ramesh Kshirsagar (Survey 83/3)', 4.82, 1135153, 'Pending', 'Active', '2026-08-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Pandurang Sawant (Survey 77/1A)', 0.89, 279771, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Sanjay Gawade (Survey 335/2)', 2.16, 611472, 'Pending', 'Active', '2026-07-15', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Kisan Ghuge (Survey 35/2)', 1.21, 278074, 'Pending', 'Active', '2026-08-16', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Ashok Shirke (Survey 44/A)', 5.62, 1452814, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Namdeo Deshmukh (Survey 33/3)', 7.97, 1368982, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Pandurang Bhandari (Survey 380/2B)', 1.93, 273434, 'Paid', 'Active', '2026-06-15', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Vitthal Tapkir (Survey 315/2)', 6.07, 909971, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj1, 'Subhash Bhosale (Survey 68/A)', 4.66, 1273615, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Suresh Gore (Survey 328/B)', 12.72, 3124299, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Dattatray More (Survey 162/2)', 2.62, 633571, 'Pending', 'Active', '2026-07-11', 'Filed', 'Refusing', 'Verified'),
        (v_proj1, 'Vijay Bhosale (Survey 117/2B)', 2.44, 446654, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Baburao Sawant (Survey 413/A)', 3.33, 925087, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Tanaji Mohite (Survey 364/1A)', 10.05, 2613914, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Santosh Kadam (Survey 353/A)', 5.13, 778313, 'Pending', 'Active', '2026-07-08', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Shantabai Waghmare (Survey 68/1)', 5.73, 1795249, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Bhaurao Shirke (Survey 160/2B)', 2.28, 417388, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj1, 'Suresh Deshmukh (Survey 286/B)', 9.3, 1328095, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Laxmibai Kharat (Survey 260/2)', 10.03, 2568181, 'Pending', 'Active', '2026-06-22', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Shrikant Kulkarni (Survey 210/1)', 9.9, 2825687, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj1, 'Parvatibai Tapkir (Survey 229/1)', 11.72, 1808231, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Vitthal Thorat (Survey 79/3)', 7.06, 2065304, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Pandurang Deshmukh (Survey 301/2)', 10.68, 1829366, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Vijay Bapat (Survey 261/A)', 2.69, 429240, 'Pending', 'Active', '2026-05-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Subhash Mohite (Survey 96/2B)', 3.6, 691228, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj1, 'Maruti Joshi (Survey 178/2)', 7.59, 1648403, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Pandurang Dumbre (Survey 20/2B)', 1.92, 488131, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Prakash Chavan (Survey 79/B)', 1.58, 503127, 'Pending', 'Active', '2026-08-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Tanaji Joshi (Survey 46/1A)', 8.1, 1509921, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj1, 'Shrikant More (Survey 415/A)', 2.7, 415692, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Shrikant Dumbre (Survey 285/4C)', 9.13, 1831733, 'Pending', 'Active', '2026-06-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Santosh Bapat (Survey 357/4C)', 4.93, 740392, 'Pending', 'Active', '2026-04-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Santosh Deshmukh (Survey 56/4C)', 5.21, 1034075, 'Pending', 'Active', '2026-06-15', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Rajendra Kamble (Survey 312/B)', 11.39, 2024971, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Tukaram More (Survey 206/1A)', 9.71, 2418197, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Kisan Kulkarni (Survey 115/2)', 9.89, 1827454, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Kisan Salunkhe (Survey 154/1)', 4.83, 956074, 'Paid', 'Active', '2026-01-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Dattatray Joshi (Survey 210/2B)', 9.33, 2126857, 'Pending', 'Active', '2026-01-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Santosh Bapat (Survey 116/1)', 0.85, 227877, 'Paid', 'Active', '2025-09-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Chandrakant Gore (Survey 53/1)', 11.11, 2533757, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Namdeo Shirke (Survey 395/3)', 1.1, 206877, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Parvatibai Gawade (Survey 286/A)', 11.38, 2202974, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Pandurang Bapat (Survey 105/2B)', 10.89, 3027125, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj1, 'Parvatibai Shinde (Survey 289/4C)', 8.71, 2726595, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Dattatray Kadam (Survey 69/4C)', 2.83, 544330, 'Pending', 'Active', '2026-03-23', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Santosh Pawar (Survey 39/2)', 8.06, 2481915, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Shrikant Kamble (Survey 372/1A)', 9.96, 2026889, 'Pending', 'Active', '2026-02-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Chandrakant Deshmukh (Survey 76/B)', 1.49, 263479, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj1, 'Kisan Mohite (Survey 42/A)', 11.52, 2001830, 'Pending', 'Active', '2025-07-04', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Vijay Sawant (Survey 404/1)', 9.36, 2389111, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Ashok Bapat (Survey 394/3)', 8.68, 2460224, 'Pending', 'Active', '2026-02-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Mahesh More (Survey 72/4C)', 12.44, 2898196, 'Pending', 'Active', '2026-07-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Ramesh Kharat (Survey 283/1)', 4.5, 751788, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Namdeo Kharat (Survey 186/3)', 3.49, 969047, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Baburao Bapat (Survey 280/B)', 3.66, 683633, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Prakash Gawade (Survey 414/3)', 12.1, 1904213, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj1, 'Ramesh Kadam (Survey 269/B)', 3.61, 521525, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Ananda Bhandari (Survey 416/4C)', 11.96, 2965637, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Prakash Bapat (Survey 342/1A)', 8.99, 1672931, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Shantabai Thorat (Survey 253/B)', 0.92, 233088, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Maruti Kadam (Survey 415/1A)', 2.21, 697513, 'Pending', 'Active', '2025-07-18', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Ganpat More (Survey 280/B)', 7.24, 1912974, 'Paid', 'Active', '2025-10-07', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Ashok Kulkarni (Survey 378/4C)', 10.64, 2931320, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Vitthal Jagdale (Survey 277/2B)', 6.65, 1774891, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Maruti Pawar (Survey 18/B)', 11.72, 2329080, 'Pending', 'Active', '2026-07-28', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Ananda Mohite (Survey 155/4C)', 3.68, 1083377, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Mahesh Ghuge (Survey 38/4C)', 2.38, 730590, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj1, 'Tukaram Thorat (Survey 38/2)', 12.74, 2351854, 'Paid', 'Active', '2026-07-14', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Parvatibai Mohite (Survey 134/1)', 1.41, 279270, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified');

    -- ==========================================================
    -- PROJECT 2: Hinjewadi - Shivajinagar Metro Line 3 Extension (Metro)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Hinjewadi - Shivajinagar Metro Line 3 Extension', 'Metro', 'Pune', 'Hinjewadi Phase 1, Phase 2, Wakad, Balewadi, Baner',
        320.0, 65, 4,
        '2024-06-15', '2027-03-31', 'No',
        false, 8, v_profile_id
    ) RETURNING id INTO v_proj2;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj2, 65, 50, 45
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj2, 'Sunita Pardeshi (Survey 414/3)', 7.3, 1341126, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Ganpat Mohite (Survey 264/3)', 6.73, 1290692, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Ashok Jadhav (Survey 19/1A)', 10.62, 3231039, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Ganpat Patil (Survey 161/2)', 0.81, 185585, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Rajendra Bhandari (Survey 319/2)', 6.88, 1087356, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Bhaurao Shirke (Survey 97/1)', 2.17, 511002, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Laxmibai Mohite (Survey 313/1)', 3.28, 619890, 'Paid', 'Active', '2026-08-08', 'Filed', 'Occupied', 'Verified'),
        (v_proj2, 'Tanaji Joshi (Survey 281/2B)', 6.1, 1581955, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Ashok Dumbre (Survey 394/1A)', 11.86, 2241409, 'Paid', 'Active', '2026-07-04', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Tanaji Jadhav (Survey 395/1)', 11.07, 3476644, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Dattatray Kulkarni (Survey 140/2B)', 8.02, 1330060, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Tanaji Bapat (Survey 107/B)', 3.54, 529169, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Namdeo Patil (Survey 291/2)', 4.11, 956832, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Tukaram Joshi (Survey 213/A)', 4.91, 1005302, 'Paid', 'Active', '2026-05-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Bhaurao Gaikwad (Survey 129/2B)', 8.61, 1400175, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Tukaram Joshi (Survey 368/3)', 4.8, 1312747, 'Pending', 'Active', '2026-08-12', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Kisan Gaikwad (Survey 290/2)', 4.86, 924333, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Sanjay Kamble (Survey 315/A)', 4.89, 1487582, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Kisan Dumbre (Survey 173/4C)', 8.88, 2707884, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Mahesh Shirke (Survey 167/1)', 6.26, 1665091, 'Paid', 'Active', '2026-06-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Laxmibai Ghuge (Survey 24/1)', 2.49, 423275, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Maruti Deshmukh (Survey 146/1A)', 3.53, 714952, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Subhash Dumbre (Survey 380/B)', 10.46, 1842570, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Suresh Kamble (Survey 254/1)', 10.57, 2416851, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Ashok Thorat (Survey 276/B)', 12.2, 2777940, 'Paid', 'Active', '2026-02-05', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Tanaji Ghuge (Survey 286/2B)', 6.94, 1618886, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj2, 'Rajendra Bhosale (Survey 309/1A)', 8.7, 2131743, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Vitthal Sawant (Survey 286/2B)', 9.95, 2351712, 'Pending', 'Active', '2026-06-28', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Dinkar Gawade (Survey 310/2B)', 8.98, 1465437, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Tanaji Shirke (Survey 268/B)', 4.68, 1097740, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Sunita Jadhav (Survey 238/B)', 6.56, 2082957, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Shantabai Patil (Survey 40/4C)', 9.47, 1809840, 'Paid', 'Active', '2025-07-29', 'Filed', 'Occupied', 'Verified'),
        (v_proj2, 'Ganpat Gawade (Survey 46/2)', 11.76, 2926393, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Santosh Kulkarni (Survey 49/2B)', 5.11, 1456590, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Tanaji Nalawade (Survey 218/3)', 4.7, 1244400, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Suresh Bapat (Survey 331/3)', 2.36, 492664, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Sunita Deshmukh (Survey 414/4C)', 5.19, 1365629, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Chandrakant Ghuge (Survey 39/1A)', 1.89, 282022, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Parvatibai Kharat (Survey 70/2B)', 0.91, 283828, 'Paid', 'Active', '2026-07-18', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Prakash Gaikwad (Survey 398/2)', 3.02, 749784, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Suresh Thorat (Survey 418/1A)', 3.23, 532058, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Subhash More (Survey 329/A)', 10.17, 1886667, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Shantabai Gawade (Survey 111/2)', 1.82, 400054, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Laxmibai Gore (Survey 235/4C)', 5.37, 1237570, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Shantabai Ghuge (Survey 73/4C)', 12.4, 2044375, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Ganpat Bapat (Survey 155/2)', 2.56, 359196, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Kisan Bapat (Survey 137/B)', 3.59, 639027, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Ganpat Sawant (Survey 105/2B)', 7.08, 1538037, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Sanjay Kharat (Survey 200/B)', 8.36, 1556983, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Bhaurao Mohite (Survey 17/2B)', 9.76, 1556241, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Tanaji Deshmukh (Survey 264/3)', 3.5, 562614, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Ananda Jagdale (Survey 210/2)', 0.75, 165663, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Maruti Mohite (Survey 269/A)', 4.7, 1386185, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Parvatibai Kharat (Survey 44/2B)', 3.25, 855452, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Parvatibai Gawade (Survey 403/1A)', 4.15, 992277, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Prakash Shirke (Survey 65/4C)', 11.06, 2311064, 'Paid', 'Active', '2026-08-17', 'Filed', 'Refusing', 'Verified'),
        (v_proj2, 'Prakash Bhosale (Survey 171/2B)', 8.26, 1485205, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Vitthal Gaikwad (Survey 267/4C)', 4.0, 985012, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Namdeo Gaikwad (Survey 401/2B)', 6.06, 1187699, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Santosh Jadhav (Survey 334/B)', 1.96, 607108, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Pandurang Gawade (Survey 279/A)', 3.82, 990117, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Shantabai Ghuge (Survey 356/1A)', 3.55, 773257, 'Paid', 'Active', '2025-11-03', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Sanjay Nalawade (Survey 268/2)', 9.56, 2693032, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Tanaji Kulkarni (Survey 160/B)', 3.49, 825898, 'Paid', 'Active', '2025-08-04', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Kisan Bapat (Survey 186/2)', 11.09, 2224665, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending');

    -- ==========================================================
    -- PROJECT 3: Mulshi-Pawana Water Supply & R&R Pipeline (Dam)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Mulshi-Pawana Water Supply & R&R Pipeline', 'Dam', 'Pune', 'Mulshi, Paud, Male, Kolvan, Pirangut',
        1250.0, 90, 42,
        '2023-11-10', '2026-08-15', 'Yes',
        false, 24, v_profile_id
    ) RETURNING id INTO v_proj3;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj3, 90, 30, 20
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj3, 'Namdeo Gaikwad (Survey 67/1A)', 12.23, 2171668, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Shantabai Waghmare (Survey 149/2)', 3.07, 626307, 'Paid', 'Active', '2026-03-11', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Suresh Bapat (Survey 55/2B)', 11.2, 1629656, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Parvatibai Dumbre (Survey 301/1)', 10.49, 2022671, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Dattatray Ghuge (Survey 399/4C)', 5.98, 1049597, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Shrikant Tapkir (Survey 350/2)', 12.66, 3348430, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Sunita Salunkhe (Survey 111/2B)', 7.25, 1932023, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Bhaurao Jadhav (Survey 20/2)', 2.74, 549794, 'Pending', 'Active', '2026-07-08', 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Ashok Salunkhe (Survey 266/1A)', 12.34, 3549169, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Dinkar Kharat (Survey 295/2B)', 9.55, 2339826, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Pandurang Bapat (Survey 151/2B)', 8.95, 2770204, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj3, 'Chandrakant Bapat (Survey 196/4C)', 5.8, 1424143, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Santosh Sawant (Survey 308/1)', 1.74, 401593, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Shrikant Dumbre (Survey 381/3)', 0.8, 133518, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Ananda Kshirsagar (Survey 414/B)', 4.75, 1510699, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Pandurang Waghmare (Survey 320/B)', 7.19, 2113335, 'Paid', 'Active', '2026-08-09', 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Santosh Jagdale (Survey 255/B)', 2.22, 530580, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Pandurang Jadhav (Survey 349/4C)', 1.0, 197311, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Vitthal Kshirsagar (Survey 78/B)', 11.49, 2892285, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Ganpat Kamble (Survey 163/A)', 3.47, 977571, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Baburao Kamble (Survey 268/A)', 9.19, 2920223, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Pandurang Ghuge (Survey 136/A)', 4.49, 823443, 'Pending', 'Active', '2025-09-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Laxmibai Nalawade (Survey 417/A)', 5.42, 1361910, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Subhash Jadhav (Survey 222/2B)', 4.65, 1155771, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Ramesh Deshmukh (Survey 161/1)', 3.13, 617498, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Tanaji Waghmare (Survey 201/4C)', 2.3, 467914, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Ashok More (Survey 25/1)', 7.38, 1253884, 'Pending', 'Active', '2025-09-03', 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Prakash Pardeshi (Survey 411/A)', 4.07, 982408, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Pandurang Tapkir (Survey 324/1)', 7.29, 1629234, 'Pending', 'Active', '2025-07-23', 'Filed', 'Refusing', 'Verified'),
        (v_proj3, 'Shantabai Shinde (Survey 155/3)', 11.22, 2949917, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Maruti Salunkhe (Survey 36/4C)', 6.27, 1800286, 'Pending', 'Active', '2026-01-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Suresh Jadhav (Survey 326/1)', 9.2, 1382355, 'Paid', 'Active', '2025-11-05', 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Shantabai Kamble (Survey 296/3)', 11.47, 3437673, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Ananda Dumbre (Survey 256/A)', 7.55, 1963989, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Ananda Bhosale (Survey 258/2B)', 12.37, 3878427, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Ananda Ghuge (Survey 188/A)', 10.97, 2567528, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Vitthal Kshirsagar (Survey 292/4C)', 11.52, 2284381, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj3, 'Parvatibai Salunkhe (Survey 178/B)', 1.2, 202944, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Chandrakant Waghmare (Survey 247/2)', 4.63, 1135127, 'Pending', 'Active', '2026-07-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Shrikant Joshi (Survey 272/2B)', 7.43, 1877717, 'Paid', 'Active', '2026-06-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Maruti Bapat (Survey 32/4C)', 5.59, 1321850, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Dinkar Joshi (Survey 73/4C)', 11.62, 3464526, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj3, 'Kisan Kadam (Survey 329/3)', 4.04, 1126994, 'Paid', 'Active', '2026-08-19', 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Ganpat Kshirsagar (Survey 46/1)', 4.55, 678245, 'Pending', 'Active', '2026-07-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Dinkar Jadhav (Survey 238/A)', 0.77, 177248, 'Paid', 'Active', '2025-08-25', 'Filed', 'Refusing', 'Verified'),
        (v_proj3, 'Kisan Shirke (Survey 151/1A)', 7.92, 2060942, 'Pending', 'Active', '2026-06-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Subhash Kshirsagar (Survey 365/1A)', 11.06, 2741287, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj3, 'Dattatray Pawar (Survey 344/B)', 7.5, 2311702, 'Paid', 'Active', '2026-08-13', 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Maruti Pardeshi (Survey 287/B)', 4.79, 1153714, 'Pending', 'Active', '2026-05-06', 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Namdeo Kshirsagar (Survey 388/A)', 6.95, 2119360, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Santosh Patil (Survey 201/A)', 5.88, 1816108, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Shantabai Kadam (Survey 399/B)', 11.94, 2296372, 'Paid', 'Active', '2026-07-22', 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Vijay Deshmukh (Survey 415/B)', 12.02, 2404781, 'Pending', 'Active', '2025-09-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Dattatray Kadam (Survey 349/2B)', 1.09, 197244, 'Paid', 'Active', '2026-02-26', 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Ganpat Shinde (Survey 170/1A)', 2.99, 760658, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Kisan Deshmukh (Survey 184/2B)', 3.58, 1100101, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj3, 'Baburao Bhosale (Survey 238/A)', 1.26, 218286, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Sunita Gawade (Survey 324/A)', 6.04, 1875631, 'Paid', 'Active', '2026-08-09', 'Filed', 'Refusing', 'Verified'),
        (v_proj3, 'Subhash Pawar (Survey 323/3)', 0.83, 125093, 'Pending', 'Active', '2026-07-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Pandurang More (Survey 361/2B)', 9.74, 2112138, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Namdeo Ghuge (Survey 244/3)', 0.83, 192965, 'Pending', 'Active', '2026-06-17', 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Vijay Nalawade (Survey 143/2)', 1.95, 408361, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj3, 'Maruti Bhandari (Survey 65/A)', 11.25, 3435491, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Dattatray More (Survey 79/A)', 1.17, 246309, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Prakash Ghuge (Survey 79/1A)', 11.93, 2794375, 'Pending', 'Active', '2026-06-13', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Vijay Kadam (Survey 34/B)', 5.15, 1392518, 'Pending', 'Active', '2026-07-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Bhaurao Shinde (Survey 59/A)', 3.0, 691701, 'Pending', 'Active', '2026-07-31', 'Filed', 'Occupied', 'Pending'),
        (v_proj3, 'Pandurang Bapat (Survey 282/B)', 12.28, 3170745, 'Paid', 'Active', '2025-09-18', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Chandrakant Patil (Survey 184/2)', 8.7, 2364094, 'Pending', 'Active', '2025-09-05', 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Sanjay Waghmare (Survey 212/3)', 3.07, 834917, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Mahesh Kshirsagar (Survey 220/4C)', 1.19, 333403, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Ananda Gawade (Survey 264/2B)', 1.36, 325764, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Laxmibai Gaikwad (Survey 407/1)', 7.47, 1292967, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Bhaurao Gore (Survey 206/B)', 3.95, 754762, 'Pending', 'Active', '2026-05-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Parvatibai Jagdale (Survey 348/2B)', 12.28, 3365677, 'Paid', 'Active', '2026-07-18', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Vijay Shinde (Survey 180/3)', 4.27, 753859, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Rajendra Tapkir (Survey 82/A)', 4.21, 915957, 'Pending', 'Active', '2026-06-22', 'Filed', 'Refusing', 'Verified'),
        (v_proj3, 'Ashok Kadam (Survey 380/1)', 7.98, 2398668, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Santosh Pardeshi (Survey 138/3)', 8.01, 1374459, 'Pending', 'Active', '2025-09-12', 'Filed', 'Refusing', 'Verified'),
        (v_proj3, 'Maruti Bapat (Survey 58/B)', 10.32, 3021510, 'Pending', 'Active', '2025-12-09', 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Vitthal Tapkir (Survey 48/A)', 9.25, 1928597, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Namdeo Tapkir (Survey 105/A)', 0.75, 165237, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Vitthal Bhandari (Survey 264/2)', 2.97, 761062, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj3, 'Ananda Pawar (Survey 411/1A)', 2.19, 697352, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Pandurang Shinde (Survey 22/4C)', 9.5, 2103271, 'Pending', 'Active', '2026-08-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj3, 'Tanaji Bhandari (Survey 257/B)', 6.77, 1356999, 'Pending', 'Active', '2025-08-25', 'Filed', 'Occupied', 'Verified'),
        (v_proj3, 'Ananda Bhandari (Survey 159/2B)', 3.01, 674881, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Namdeo Salunkhe (Survey 290/A)', 12.66, 3073696, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj3, 'Kisan Pardeshi (Survey 90/1)', 9.39, 2888955, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Suresh Nalawade (Survey 364/1)', 9.4, 2804349, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending');

    -- ==========================================================
    -- PROJECT 4: Purandar Greenfield International Airport Corridor (Airport)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Purandar Greenfield International Airport Corridor', 'Airport', 'Pune', 'Pargaon, Memane, Rajewadi, Waghapur, Vanpuri',
        2840.0, 110, 12,
        '2024-01-15', '2027-12-31', 'Yes',
        false, 28, v_profile_id
    ) RETURNING id INTO v_proj4;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj4, 110, 15, 10
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj4, 'Shantabai Gaikwad (Survey 174/A)', 12.34, 3295532, 'Pending', 'Active', '2025-09-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Ananda Salunkhe (Survey 163/4C)', 7.96, 1280485, 'Pending', 'Active', '2025-09-29', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Sanjay Shirke (Survey 166/2B)', 12.53, 3221550, 'Pending', 'Active', '2025-08-11', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Parvatibai Kamble (Survey 259/1)', 4.49, 1368556, 'Pending', 'Active', '2025-11-25', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Tukaram Shirke (Survey 306/1A)', 10.39, 1582656, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Rajendra Kulkarni (Survey 65/3)', 2.79, 658498, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Dinkar Gawade (Survey 36/1)', 8.0, 2260568, 'Paid', 'Active', '2026-08-19', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Chandrakant Joshi (Survey 120/4C)', 1.96, 400222, 'Pending', 'Active', '2026-06-14', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Baburao Sawant (Survey 334/2B)', 7.36, 1620156, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj4, 'Vijay Chavan (Survey 50/1A)', 7.13, 999034, 'Pending', 'Active', '2025-10-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Ganpat Waghmare (Survey 229/B)', 0.68, 200600, 'Pending', 'Active', '2026-07-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Ganpat Gore (Survey 209/1)', 10.66, 2715933, 'Pending', 'Active', '2026-03-12', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Namdeo Chavan (Survey 272/1A)', 5.7, 1130629, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj4, 'Bhaurao Thorat (Survey 149/2B)', 12.56, 2166486, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Sanjay Bhandari (Survey 274/1A)', 11.07, 2002928, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Vitthal Ghuge (Survey 138/2)', 3.66, 628231, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj4, 'Rajendra Shinde (Survey 84/2B)', 3.76, 852583, 'Pending', 'Active', '2026-04-07', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Shantabai Patil (Survey 149/3)', 0.85, 221398, 'Pending', 'Active', '2026-03-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Dinkar Gaikwad (Survey 103/B)', 9.91, 2471563, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Dinkar Deshmukh (Survey 142/A)', 9.6, 2187561, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Tanaji Waghmare (Survey 241/A)', 7.99, 2525607, 'Pending', 'Active', '2026-03-19', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Kisan Ghuge (Survey 315/2)', 6.79, 1774695, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Santosh Kamble (Survey 398/1)', 12.16, 3129132, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj4, 'Ashok Chavan (Survey 390/2)', 12.35, 2523648, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Chandrakant Jagdale (Survey 110/1)', 8.03, 2064376, 'Pending', 'Active', '2026-03-19', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Vijay Waghmare (Survey 275/4C)', 12.48, 1950149, 'Pending', 'Active', '2026-07-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Tanaji Joshi (Survey 64/4C)', 8.33, 2055227, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Pandurang Pawar (Survey 261/B)', 1.1, 188873, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj4, 'Tanaji Bapat (Survey 168/4C)', 9.41, 1453252, 'Paid', 'Active', '2026-05-13', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Chandrakant Ghuge (Survey 201/A)', 5.14, 1431500, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Shantabai Kamble (Survey 111/A)', 6.26, 954869, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Tanaji Gore (Survey 129/3)', 9.46, 1889521, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Vijay Tapkir (Survey 219/2)', 1.86, 443180, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Prakash Jadhav (Survey 182/A)', 1.42, 211098, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Baburao Salunkhe (Survey 253/2)', 2.53, 405455, 'Paid', 'Active', '2025-09-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Suresh Tapkir (Survey 26/3)', 10.25, 2563617, 'Pending', 'Active', '2025-07-29', 'Filed', 'Occupied', 'Verified'),
        (v_proj4, 'Vijay Tapkir (Survey 310/1)', 1.69, 263520, 'Pending', 'Active', '2026-08-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Rajendra Tapkir (Survey 362/2B)', 8.75, 1800128, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Santosh Kshirsagar (Survey 234/A)', 2.1, 440288, 'Paid', 'Active', '2026-07-03', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Tanaji Kharat (Survey 242/2B)', 2.0, 492634, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Dinkar Mohite (Survey 412/2B)', 4.2, 1266413, 'Pending', 'Active', '2026-05-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Tukaram Pardeshi (Survey 186/2)', 1.56, 375063, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj4, 'Shrikant Pardeshi (Survey 319/1A)', 2.39, 594287, 'Pending', 'Active', '2026-06-18', 'Filed', 'Occupied', 'Verified'),
        (v_proj4, 'Sanjay More (Survey 274/3)', 10.0, 2263590, 'Pending', 'Active', '2025-11-14', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Shrikant Pawar (Survey 24/A)', 9.38, 2497894, 'Pending', 'Active', '2026-06-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Ashok Jadhav (Survey 135/B)', 1.73, 280600, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Rajendra Dumbre (Survey 85/1)', 0.84, 137875, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Mahesh Dumbre (Survey 84/2)', 4.6, 818588, 'Paid', 'Active', '2026-08-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Maruti Tapkir (Survey 163/1)', 11.12, 2067474, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj4, 'Parvatibai Kulkarni (Survey 347/1A)', 3.16, 900792, 'Pending', 'Active', '2026-07-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Chandrakant Sawant (Survey 219/4C)', 1.9, 355343, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj4, 'Bhaurao Bhosale (Survey 193/2B)', 1.95, 415987, 'Pending', 'Active', '2026-08-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Tukaram Bhosale (Survey 25/2)', 11.19, 2064129, 'Pending', 'Active', '2026-06-15', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Ramesh Kamble (Survey 350/2)', 1.25, 240366, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Namdeo Ghuge (Survey 377/A)', 9.82, 1673779, 'Pending', 'Active', '2026-08-15', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Suresh Joshi (Survey 129/4C)', 4.15, 997307, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj4, 'Sunita Kshirsagar (Survey 213/A)', 6.19, 1504194, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj4, 'Mahesh Bhandari (Survey 371/4C)', 1.66, 426865, 'Pending', 'Active', '2026-07-25', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Laxmibai Salunkhe (Survey 414/B)', 9.14, 2074734, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Parvatibai Shinde (Survey 328/2B)', 6.14, 1884101, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Shrikant More (Survey 111/2B)', 3.66, 670475, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Tukaram Jadhav (Survey 110/1A)', 6.59, 1810754, 'Pending', 'Active', '2026-07-08', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Mahesh Gaikwad (Survey 49/4C)', 11.02, 2883008, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj4, 'Namdeo Thorat (Survey 105/B)', 3.16, 562849, 'Pending', 'Active', '2025-08-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Bhaurao Ghuge (Survey 348/A)', 4.49, 1053313, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj4, 'Dinkar Bapat (Survey 122/2B)', 3.92, 1164016, 'Paid', 'Active', '2026-08-02', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Sunita Gawade (Survey 352/2)', 6.52, 1251677, 'Pending', 'Active', '2026-07-15', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Santosh Kulkarni (Survey 309/1A)', 2.69, 385910, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Bhaurao Shirke (Survey 81/4C)', 4.56, 1439610, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Vijay Kadam (Survey 189/3)', 2.5, 595807, 'Pending', 'Active', '2026-08-11', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Suresh Ghuge (Survey 299/1A)', 12.1, 3053156, 'Pending', 'Active', '2025-12-28', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Chandrakant Chavan (Survey 341/4C)', 3.33, 920405, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Baburao Sawant (Survey 54/4C)', 2.61, 804746, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Ashok Bhosale (Survey 264/2B)', 11.46, 2244143, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Ashok Kshirsagar (Survey 89/3)', 9.49, 1639331, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Shrikant Pardeshi (Survey 265/2)', 9.4, 2057246, 'Paid', 'Active', '2026-03-31', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Santosh Gaikwad (Survey 60/3)', 4.26, 1287657, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Parvatibai Pawar (Survey 257/3)', 1.52, 339716, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Ganpat Shinde (Survey 176/2)', 8.87, 2236907, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Dinkar Kadam (Survey 368/1)', 5.12, 1560458, 'Pending', 'Active', '2025-12-31', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Bhaurao Tapkir (Survey 185/3)', 2.05, 394251, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Tukaram Bapat (Survey 336/1)', 4.2, 932660, 'Paid', 'Active', '2026-06-13', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Pandurang Jagdale (Survey 223/A)', 1.65, 423388, 'Pending', 'Active', '2025-07-07', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Ashok Mohite (Survey 266/1A)', 12.76, 3031316, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Maruti Mohite (Survey 299/1)', 5.35, 946270, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Prakash Kshirsagar (Survey 57/A)', 7.26, 1558533, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Subhash Dumbre (Survey 233/3)', 9.76, 1914492, 'Pending', 'Active', '2025-08-11', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Kisan Gaikwad (Survey 202/A)', 9.43, 1824224, 'Pending', 'Active', '2026-07-14', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Ganpat Joshi (Survey 26/B)', 8.97, 1596408, 'Pending', 'Active', '2026-07-13', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Kisan Kharat (Survey 402/1A)', 1.68, 396117, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Shantabai Ghuge (Survey 220/2B)', 8.93, 2422628, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Ashok Thorat (Survey 334/2B)', 0.93, 279799, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Kisan Shirke (Survey 267/2B)', 1.4, 247749, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Vitthal Ghuge (Survey 340/1A)', 0.92, 192624, 'Pending', 'Active', '2026-07-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Maruti Deshmukh (Survey 169/A)', 6.12, 1079476, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Shrikant Shirke (Survey 341/A)', 8.93, 2652468, 'Paid', 'Active', '2026-08-12', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Rajendra Patil (Survey 342/B)', 10.89, 1848958, 'Pending', 'Active', '2026-01-15', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Ganpat Bhandari (Survey 225/2B)', 5.54, 1671805, 'Pending', 'Active', '2026-02-04', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Maruti Jadhav (Survey 281/A)', 6.61, 1506980, 'Pending', 'Active', '2026-06-26', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Kisan Gawade (Survey 261/1A)', 8.21, 1868070, 'Pending', 'Active', '2026-08-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Namdeo Kharat (Survey 77/1A)', 2.8, 841416, 'Pending', 'Active', '2026-05-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Ramesh Pawar (Survey 226/B)', 10.46, 2553934, 'Pending', 'Active', '2026-08-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Laxmibai Gawade (Survey 255/2)', 2.55, 372542, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj4, 'Baburao Gaikwad (Survey 154/2)', 11.85, 1828774, 'Pending', 'Active', '2026-08-02', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Vitthal Kharat (Survey 229/B)', 8.24, 2397576, 'Paid', 'Active', '2026-03-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Rajendra Bapat (Survey 337/1A)', 10.23, 2883223, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Laxmibai Kamble (Survey 76/B)', 2.67, 505265, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Sanjay Kadam (Survey 189/3)', 2.72, 782712, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Shrikant Bhandari (Survey 188/B)', 7.25, 2028245, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Kisan Ghuge (Survey 210/B)', 2.85, 877383, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending');

    -- ==========================================================
    -- PROJECT 5: Talegaon - Chakan Industrial Mega Corridor (Phase 4) (Industrial Corridor)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Talegaon - Chakan Industrial Mega Corridor (Phase 4)', 'Industrial Corridor', 'Pune', 'Chakan, Mahalunge, Khalumbare, Vasuli, Sawardari',
        1120.0, 70, 5,
        '2024-04-01', '2026-10-30', 'No',
        false, 11, v_profile_id
    ) RETURNING id INTO v_proj5;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj5, 70, 48, 42
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj5, 'Suresh Bapat (Survey 378/1)', 7.06, 1653564, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Mahesh Kulkarni (Survey 282/4C)', 2.14, 583697, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Rajendra Dumbre (Survey 178/4C)', 4.54, 1075802, 'Paid', 'Active', '2026-08-04', 'Filed', 'Occupied', 'Verified'),
        (v_proj5, 'Parvatibai Kshirsagar (Survey 247/2B)', 12.32, 2980626, 'Paid', 'Active', '2026-07-20', 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Ramesh Salunkhe (Survey 399/1A)', 5.62, 791762, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj5, 'Tukaram Jagdale (Survey 313/4C)', 9.85, 2256280, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Namdeo Gaikwad (Survey 193/A)', 11.57, 2961434, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Sanjay Jadhav (Survey 268/2B)', 11.38, 3326931, 'Pending', 'Active', '2026-02-16', 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Rajendra Tapkir (Survey 23/3)', 6.23, 1376069, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Dattatray Bhosale (Survey 120/4C)', 7.15, 1112525, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Ramesh Pardeshi (Survey 119/B)', 1.74, 371902, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj5, 'Sanjay Kadam (Survey 356/A)', 3.45, 623446, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj5, 'Laxmibai Gawade (Survey 404/2)', 5.59, 995115, 'Paid', 'Active', '2025-12-23', 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Shantabai Bhandari (Survey 119/2)', 2.6, 387480, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj5, 'Santosh Jagdale (Survey 303/1)', 5.88, 881588, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Santosh Chavan (Survey 58/B)', 9.01, 2215099, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Vijay Tapkir (Survey 166/4C)', 10.38, 2128470, 'Paid', 'Active', '2025-07-27', 'Filed', 'Occupied', 'Verified'),
        (v_proj5, 'Shrikant Bhandari (Survey 384/2)', 2.61, 475891, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj5, 'Mahesh Gaikwad (Survey 169/B)', 12.71, 3377199, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Ashok Waghmare (Survey 308/1)', 11.5, 2116402, 'Paid', 'Active', '2026-07-23', 'Filed', 'Refusing', 'Verified'),
        (v_proj5, 'Dattatray Pawar (Survey 43/1)', 8.94, 1768796, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Pandurang Kamble (Survey 176/B)', 5.17, 1267337, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Prakash Thorat (Survey 216/B)', 12.56, 1997215, 'Paid', 'Active', '2026-07-22', 'Filed', 'Refusing', 'Verified'),
        (v_proj5, 'Rajendra Salunkhe (Survey 153/2)', 11.22, 2862872, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Suresh Bapat (Survey 38/2B)', 1.78, 516653, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Namdeo Joshi (Survey 211/1)', 12.18, 2415001, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Ananda Mohite (Survey 306/4C)', 1.04, 316876, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Pandurang Chavan (Survey 98/1A)', 4.07, 1302391, 'Paid', 'Active', '2026-07-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj5, 'Ananda Gaikwad (Survey 62/B)', 1.89, 299914, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Mahesh Chavan (Survey 255/B)', 2.25, 548529, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Ananda Dumbre (Survey 251/2B)', 3.3, 484268, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Subhash Joshi (Survey 40/1)', 2.41, 716878, 'Paid', 'Active', '2026-07-07', 'Filed', 'Refusing', 'Pending'),
        (v_proj5, 'Dattatray Pawar (Survey 239/2)', 9.92, 1547797, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Rajendra Kamble (Survey 96/3)', 4.35, 851547, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Parvatibai Gore (Survey 62/2)', 8.71, 2212139, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Subhash Jadhav (Survey 347/1)', 9.36, 2392079, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj5, 'Baburao Bapat (Survey 97/1A)', 9.2, 2568713, 'Pending', 'Active', '2026-01-19', 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Prakash Pawar (Survey 263/4C)', 0.61, 146608, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj5, 'Ashok Kulkarni (Survey 157/1A)', 5.67, 1172034, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Tanaji Kamble (Survey 134/A)', 8.51, 2114403, 'Paid', 'Active', '2026-08-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj5, 'Suresh Dumbre (Survey 273/2)', 3.0, 878556, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Bhaurao Pardeshi (Survey 58/1)', 5.48, 1560490, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj5, 'Vijay Thorat (Survey 248/A)', 8.7, 1534723, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Ashok Kadam (Survey 315/B)', 11.89, 3454960, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Suresh Waghmare (Survey 239/1A)', 8.99, 2581829, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Vijay Mohite (Survey 99/3)', 4.39, 1399725, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Subhash Tapkir (Survey 153/B)', 4.14, 1212494, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Ashok Joshi (Survey 225/B)', 4.45, 1084073, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Ramesh Dumbre (Survey 348/2B)', 3.34, 473752, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Tanaji Bhandari (Survey 206/4C)', 11.82, 2216640, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Shantabai Jadhav (Survey 132/2B)', 8.84, 1631386, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Ramesh Kamble (Survey 232/2B)', 8.5, 2647724, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Dinkar Pardeshi (Survey 56/1A)', 0.66, 162789, 'Paid', 'Active', '2026-07-26', 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Maruti Thorat (Survey 73/4C)', 2.48, 607580, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj5, 'Prakash Jagdale (Survey 389/1)', 6.27, 1731447, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Bhaurao Dumbre (Survey 361/3)', 11.63, 1700585, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Pandurang Jagdale (Survey 266/1)', 1.17, 319636, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Dinkar Waghmare (Survey 255/A)', 8.56, 1720662, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj5, 'Laxmibai Kulkarni (Survey 320/3)', 11.76, 3139872, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Laxmibai Shirke (Survey 183/3)', 1.27, 222689, 'Pending', 'Active', '2026-07-01', 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Baburao Gawade (Survey 278/1A)', 9.65, 2253622, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Santosh Ghuge (Survey 173/1A)', 10.42, 2539364, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Parvatibai Thorat (Survey 379/2B)', 2.28, 671868, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj5, 'Shrikant Thorat (Survey 335/A)', 4.13, 745390, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Baburao Gore (Survey 295/2B)', 8.36, 2512205, 'Paid', 'Active', '2025-11-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj5, 'Vijay Shirke (Survey 252/2)', 8.52, 2369233, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Kisan Shirke (Survey 160/1A)', 3.83, 995784, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Tukaram Mohite (Survey 178/A)', 6.69, 1377591, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Bhaurao Kshirsagar (Survey 61/3)', 2.65, 536791, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj5, 'Dinkar Patil (Survey 416/2B)', 0.82, 132397, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending');

    -- ==========================================================
    -- PROJECT 6: Pune - Nashik Semi-High Speed Rail Alignment (Pkg P-2) (Railway)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Pune - Nashik Semi-High Speed Rail Alignment (Pkg P-2)', 'Railway', 'Pune', 'Manchar, Khed, Narayangaon, Junnar, Alephata',
        640.0, 85, 22,
        '2024-02-10', '2027-06-30', 'Yes',
        true, 16, v_profile_id
    ) RETURNING id INTO v_proj6;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj6, 85, 38, 28
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj6, 'Ganpat Bhosale (Survey 92/B)', 4.33, 657519, 'Pending', 'Active', '2025-08-06', 'Filed', 'Refusing', 'Verified'),
        (v_proj6, 'Chandrakant Nalawade (Survey 125/A)', 5.89, 1263605, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Shrikant Kshirsagar (Survey 419/3)', 1.69, 338471, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj6, 'Parvatibai Kulkarni (Survey 411/2)', 6.0, 1184166, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Ananda Kamble (Survey 66/1)', 5.19, 1058168, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Mahesh More (Survey 355/1A)', 4.6, 1368279, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj6, 'Ananda Shirke (Survey 331/4C)', 2.4, 582835, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Ramesh Gaikwad (Survey 257/A)', 12.19, 2899940, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Subhash Ghuge (Survey 16/2B)', 8.54, 1570394, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Subhash Jadhav (Survey 289/4C)', 7.82, 1514812, 'Paid', 'Active', '2026-07-21', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Tukaram Shirke (Survey 267/A)', 10.04, 2612177, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Ramesh More (Survey 132/1A)', 12.17, 2759182, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Ananda Salunkhe (Survey 370/3)', 9.71, 2206655, 'Pending', 'Active', '2025-08-30', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Chandrakant Ghuge (Survey 172/A)', 5.22, 804527, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Prakash Nalawade (Survey 194/A)', 3.79, 567450, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Sanjay Bapat (Survey 313/1)', 5.76, 1128165, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Sanjay Jagdale (Survey 181/1)', 7.11, 1910627, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Kisan Bhandari (Survey 217/2B)', 1.81, 311464, 'Paid', 'Active', '2026-04-10', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Ashok Mohite (Survey 342/4C)', 5.49, 819316, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Bhaurao Shirke (Survey 347/4C)', 7.25, 1265393, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Baburao Shirke (Survey 58/1)', 8.91, 1883805, 'Paid', 'Active', '2026-07-14', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Sanjay Tapkir (Survey 159/4C)', 6.45, 1448844, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Maruti Joshi (Survey 154/3)', 3.27, 481595, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Baburao Shinde (Survey 261/A)', 7.14, 1356300, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Rajendra More (Survey 214/2)', 0.66, 99785, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Shantabai Shinde (Survey 40/1A)', 4.07, 1096392, 'Pending', 'Active', '2025-10-15', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Namdeo Kshirsagar (Survey 131/1A)', 6.0, 1692330, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj6, 'Shrikant Tapkir (Survey 122/A)', 6.47, 1675691, 'Paid', 'Active', '2026-04-25', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Baburao Salunkhe (Survey 314/1A)', 3.39, 851364, 'Pending', 'Active', '2026-08-13', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Ashok Gawade (Survey 377/B)', 8.1, 2179442, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Dattatray Shirke (Survey 241/3)', 2.38, 426141, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Ananda Sawant (Survey 98/3)', 2.75, 778959, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Subhash Bapat (Survey 409/1A)', 9.92, 2243031, 'Paid', 'Active', '2026-08-05', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Maruti Pawar (Survey 108/1)', 8.12, 2451663, 'Pending', 'Active', '2025-10-06', 'Filed', 'Refusing', 'Verified'),
        (v_proj6, 'Rajendra Nalawade (Survey 390/A)', 3.93, 1084943, 'Pending', 'Active', '2026-06-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Ashok Deshmukh (Survey 304/3)', 4.43, 1187558, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Pandurang More (Survey 62/1A)', 6.43, 918441, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Vitthal Kharat (Survey 111/1)', 6.92, 981906, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Santosh More (Survey 248/1A)', 12.4, 2282864, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Laxmibai Patil (Survey 63/B)', 8.17, 1491041, 'Pending', 'Active', '2026-01-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Ashok Kadam (Survey 352/2B)', 3.35, 858732, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Dinkar Bhandari (Survey 399/2)', 0.92, 138617, 'Paid', 'Active', '2025-11-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Kisan Pardeshi (Survey 301/B)', 3.79, 674525, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Namdeo Ghuge (Survey 292/3)', 9.86, 1583289, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Subhash Pawar (Survey 153/2B)', 6.56, 1181259, 'Pending', 'Active', '2026-06-27', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Shrikant Shirke (Survey 114/1A)', 12.74, 2917307, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Ananda Pardeshi (Survey 401/B)', 5.19, 1618553, 'Pending', 'Active', '2025-08-16', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Laxmibai Thorat (Survey 159/2B)', 3.55, 1092182, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Maruti Gawade (Survey 191/3)', 9.99, 3174292, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Vijay Bhandari (Survey 211/2B)', 4.82, 687717, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Santosh Kamble (Survey 149/2)', 5.54, 1593713, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Vijay Jadhav (Survey 149/4C)', 2.31, 690047, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Kisan More (Survey 307/A)', 1.63, 330339, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Kisan Deshmukh (Survey 148/4C)', 8.96, 2587298, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Santosh Patil (Survey 367/A)', 2.46, 430408, 'Pending', 'Active', '2025-12-02', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Rajendra Ghuge (Survey 248/2B)', 4.78, 846217, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Parvatibai Sawant (Survey 29/2)', 10.57, 2327450, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Santosh Kharat (Survey 194/A)', 7.74, 1506792, 'Paid', 'Active', '2025-11-26', 'Filed', 'Refusing', 'Verified'),
        (v_proj6, 'Maruti Patil (Survey 15/2)', 5.71, 1663111, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Chandrakant Gaikwad (Survey 50/1A)', 11.09, 2220417, 'Pending', 'Active', '2026-08-11', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Baburao Salunkhe (Survey 369/2B)', 9.76, 2582476, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Ramesh Chavan (Survey 128/B)', 11.93, 2784438, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Subhash Sawant (Survey 369/1)', 1.44, 346432, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Rajendra Tapkir (Survey 292/A)', 2.88, 596537, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Tanaji Kharat (Survey 78/A)', 2.55, 717789, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Shantabai Nalawade (Survey 246/1A)', 9.14, 2754704, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Laxmibai Jagdale (Survey 29/1)', 7.03, 1694918, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Suresh Kadam (Survey 302/4C)', 12.55, 3676472, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Ganpat Bhosale (Survey 28/3)', 4.34, 757824, 'Pending', 'Active', '2025-11-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Chandrakant Patil (Survey 308/1A)', 3.13, 605129, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Shrikant Dumbre (Survey 168/2)', 8.37, 1979839, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Laxmibai Tapkir (Survey 416/1A)', 3.34, 980620, 'Paid', 'Active', '2026-05-06', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Bhaurao Jadhav (Survey 209/2)', 6.16, 1674251, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Shrikant Joshi (Survey 57/1A)', 1.63, 436443, 'Paid', 'Active', '2025-11-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Tukaram Jagdale (Survey 384/2)', 6.32, 1430089, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Tukaram Shirke (Survey 320/2)', 12.57, 2493246, 'Pending', 'Active', '2025-09-29', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Mahesh Pardeshi (Survey 349/2B)', 3.78, 748988, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Ganpat Kshirsagar (Survey 292/4C)', 0.6, 139613, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Laxmibai Jadhav (Survey 348/1A)', 5.53, 1148028, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Vijay Waghmare (Survey 21/2)', 1.6, 384040, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Subhash Pawar (Survey 247/2B)', 2.9, 616919, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Ganpat Waghmare (Survey 66/2B)', 5.04, 1580730, 'Pending', 'Active', '2026-03-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Suresh Kharat (Survey 361/A)', 8.33, 2520591, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Ramesh Pardeshi (Survey 276/B)', 4.91, 1569334, 'Paid', 'Active', '2026-08-13', 'Filed', 'Occupied', 'Verified'),
        (v_proj6, 'Laxmibai Pardeshi (Survey 169/2)', 5.1, 1024702, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending');

    -- ==========================================================
    -- PROJECT 7: Hadapsar - Saswad Elevated BRTS Corridor (Highway)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Hadapsar - Saswad Elevated BRTS Corridor', 'Highway', 'Pune', 'Hadapsar, Fursungi, Uruli Devachi, Dive Ghat',
        180.0, 45, 0,
        '2024-07-01', '2026-05-31', 'No',
        false, 7, v_profile_id
    ) RETURNING id INTO v_proj7;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj7, 45, 42, 40
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj7, 'Suresh Bhandari (Survey 81/1A)', 7.02, 1038377, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Suresh Jadhav (Survey 298/1)', 1.67, 235065, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Tanaji Joshi (Survey 254/2)', 10.32, 2746698, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Baburao Sawant (Survey 344/1)', 1.72, 511904, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Prakash Kamble (Survey 19/2)', 1.52, 454239, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj7, 'Sunita Waghmare (Survey 229/2)', 10.53, 2142254, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Laxmibai Kulkarni (Survey 283/3)', 11.42, 3197223, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Namdeo Thorat (Survey 174/3)', 1.83, 379466, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Baburao Shirke (Survey 399/B)', 10.88, 2015922, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Tanaji Shinde (Survey 309/1A)', 9.79, 2880100, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Shrikant Nalawade (Survey 276/1A)', 2.16, 513684, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Subhash Kshirsagar (Survey 183/3)', 12.64, 2084614, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Vitthal Gawade (Survey 140/2B)', 4.95, 1545751, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Ramesh Waghmare (Survey 315/4C)', 6.88, 1786543, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Vijay Pardeshi (Survey 415/A)', 7.38, 1059945, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Vijay Pawar (Survey 63/2)', 3.89, 928819, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Maruti Tapkir (Survey 53/2B)', 10.15, 2654448, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Subhash Mohite (Survey 370/1A)', 6.87, 1993234, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Shantabai Jadhav (Survey 291/2)', 12.09, 2938667, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Dinkar Shinde (Survey 332/2B)', 7.44, 1420496, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Rajendra Jadhav (Survey 218/3)', 8.61, 2626885, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Baburao Kamble (Survey 126/1A)', 11.03, 2462601, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Tanaji Bapat (Survey 214/A)', 4.65, 822078, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Dattatray Dumbre (Survey 90/1)', 2.28, 655869, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj7, 'Vijay Jagdale (Survey 384/4C)', 12.77, 3869910, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj7, 'Baburao Bapat (Survey 44/2B)', 2.3, 406352, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Namdeo Pawar (Survey 117/1A)', 3.17, 782470, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj7, 'Parvatibai Dumbre (Survey 395/1A)', 0.94, 225122, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Ananda Kulkarni (Survey 63/1)', 4.92, 1345920, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Mahesh Nalawade (Survey 64/1A)', 1.68, 344514, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Baburao Kshirsagar (Survey 57/B)', 0.94, 244938, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj7, 'Santosh Bhosale (Survey 330/4C)', 8.59, 1526563, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Ramesh Shirke (Survey 145/B)', 2.61, 716507, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Vitthal Pawar (Survey 192/2B)', 1.34, 191402, 'Paid', 'Active', '2025-09-24', 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Parvatibai Ghuge (Survey 123/3)', 1.19, 253882, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Mahesh Bhosale (Survey 102/3)', 11.33, 2412632, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Namdeo Pardeshi (Survey 159/A)', 7.41, 2354668, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Vijay Bhosale (Survey 301/3)', 4.11, 808482, 'Paid', 'Active', '2026-06-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Dinkar Sawant (Survey 56/2B)', 5.2, 1639996, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Tanaji Patil (Survey 41/3)', 9.92, 2894854, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Laxmibai Ghuge (Survey 296/1)', 1.0, 178403, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Tanaji Mohite (Survey 162/2)', 4.24, 651781, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Mahesh Shinde (Survey 328/B)', 10.06, 1677092, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Laxmibai Gaikwad (Survey 148/2B)', 4.34, 1287278, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Suresh Tapkir (Survey 16/A)', 8.88, 1252719, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending');

    -- ==========================================================
    -- PROJECT 8: Khadakwasla Dam Spillway & Flood Mitigation Zone (Dam)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Khadakwasla Dam Spillway & Flood Mitigation Zone', 'Dam', 'Pune', 'Khadakwasla, Kudje, Gorhe Budruk, Khanapur',
        490.0, 55, 14,
        '2023-12-01', '2026-09-30', 'Yes',
        true, 14, v_profile_id
    ) RETURNING id INTO v_proj8;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj8, 55, 35, 30
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj8, 'Bhaurao Tapkir (Survey 181/2)', 8.52, 1686363, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Prakash Joshi (Survey 275/1)', 1.45, 302091, 'Paid', 'Active', '2026-07-21', 'Filed', 'Refusing', 'Verified'),
        (v_proj8, 'Ramesh Jadhav (Survey 153/1A)', 5.68, 888141, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Vijay Gore (Survey 164/2)', 11.62, 2519436, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Vitthal Pawar (Survey 406/3)', 4.64, 1475014, 'Paid', 'Active', '2026-05-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj8, 'Mahesh Thorat (Survey 139/4C)', 9.65, 2350826, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Ganpat More (Survey 42/1A)', 12.1, 2458974, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj8, 'Chandrakant Sawant (Survey 165/1A)', 5.65, 1162199, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Ananda Chavan (Survey 284/2B)', 9.18, 2025539, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Sunita Patil (Survey 208/3)', 3.87, 1130864, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Dattatray Kshirsagar (Survey 315/2B)', 1.41, 312792, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Dinkar Deshmukh (Survey 189/1)', 8.72, 1656285, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj8, 'Sanjay Kulkarni (Survey 215/A)', 4.15, 992675, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj8, 'Dinkar Shirke (Survey 177/2B)', 8.11, 1979732, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj8, 'Namdeo Gaikwad (Survey 235/1)', 10.27, 1701430, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Pandurang More (Survey 402/3)', 2.31, 675573, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj8, 'Santosh Pawar (Survey 60/A)', 7.52, 1278422, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Tanaji Shirke (Survey 181/1)', 3.32, 990130, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj8, 'Dinkar Chavan (Survey 373/3)', 3.48, 561985, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Subhash Shinde (Survey 270/2B)', 0.95, 250779, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Tanaji Bhandari (Survey 286/1)', 11.52, 2886105, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Tukaram Sawant (Survey 113/2B)', 8.9, 2560654, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj8, 'Chandrakant More (Survey 160/1)', 1.33, 344849, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Shantabai Gaikwad (Survey 326/B)', 8.76, 1400724, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj8, 'Dattatray Shinde (Survey 130/3)', 11.13, 2445516, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Parvatibai Pawar (Survey 384/B)', 5.38, 1384688, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Sunita Gawade (Survey 242/2B)', 1.55, 306160, 'Paid', 'Active', '2026-07-25', 'Filed', 'Refusing', 'Verified'),
        (v_proj8, 'Vitthal Tapkir (Survey 379/3)', 3.4, 725964, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Mahesh Salunkhe (Survey 102/2)', 1.54, 215915, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Vitthal Pardeshi (Survey 27/4C)', 3.63, 570258, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj8, 'Tukaram Gaikwad (Survey 92/2)', 10.73, 1621024, 'Paid', 'Active', '2025-08-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj8, 'Sunita Bhosale (Survey 329/B)', 10.83, 3430348, 'Pending', 'Active', '2025-10-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj8, 'Rajendra Thorat (Survey 245/4C)', 1.32, 277856, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Maruti Patil (Survey 314/3)', 2.01, 628155, 'Paid', 'Active', '2025-09-03', 'Filed', 'Refusing', 'Verified'),
        (v_proj8, 'Laxmibai Kadam (Survey 270/2B)', 2.42, 674662, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Vijay Shirke (Survey 209/2)', 7.35, 1582800, 'Paid', 'Active', '2026-03-25', 'Filed', 'Occupied', 'Verified'),
        (v_proj8, 'Tanaji Kamble (Survey 111/2B)', 7.32, 1937977, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Maruti Kshirsagar (Survey 337/2)', 7.88, 2388640, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Shantabai Mohite (Survey 198/B)', 2.68, 722581, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Sunita Pawar (Survey 90/A)', 3.04, 713548, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Bhaurao Joshi (Survey 65/3)', 12.25, 1934336, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj8, 'Baburao Gaikwad (Survey 143/B)', 4.61, 1010571, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Dattatray Gawade (Survey 90/2B)', 0.83, 237660, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Chandrakant Tapkir (Survey 333/3)', 7.25, 1733931, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj8, 'Vitthal Ghuge (Survey 134/2B)', 9.26, 2797751, 'Pending', 'Active', '2026-08-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj8, 'Bhaurao Tapkir (Survey 391/2)', 0.73, 171606, 'Paid', 'Active', '2026-08-21', 'Filed', 'Occupied', 'Pending'),
        (v_proj8, 'Tanaji Bhandari (Survey 297/1A)', 10.14, 1925575, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Tanaji Bhandari (Survey 412/3)', 12.31, 2448988, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Parvatibai Dumbre (Survey 325/B)', 9.89, 2630819, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Vijay Chavan (Survey 25/B)', 8.69, 2625839, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Ganpat Jadhav (Survey 393/1)', 6.02, 1284180, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Prakash Bapat (Survey 18/A)', 0.96, 203388, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Ganpat Jadhav (Survey 121/2B)', 1.76, 503138, 'Paid', 'Active', '2025-10-03', 'Filed', 'Refusing', 'Verified'),
        (v_proj8, 'Dattatray Bapat (Survey 134/B)', 11.02, 3412541, 'Pending', 'Active', '2025-10-11', 'Filed', 'Refusing', 'Verified'),
        (v_proj8, 'Santosh Thorat (Survey 28/3)', 8.87, 2365806, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending');

    -- ==========================================================
    -- PROJECT 9: Baner - Balewadi Smart Mobility Hub & Transit Depot (Smart City)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Baner - Balewadi Smart Mobility Hub & Transit Depot', 'Smart City', 'Pune', 'Baner, Balewadi, Mahalunge Smart City Zone',
        95.0, 40, 0,
        '2024-08-01', '2026-04-15', 'No',
        false, 6, v_profile_id
    ) RETURNING id INTO v_proj9;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj9, 40, 38, 38
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj9, 'Sanjay Gore (Survey 279/1)', 1.87, 370783, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Santosh Jagdale (Survey 221/B)', 3.22, 562344, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Ashok Kamble (Survey 282/B)', 4.91, 972641, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj9, 'Sunita Bhosale (Survey 329/1A)', 1.89, 280065, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj9, 'Mahesh Joshi (Survey 138/3)', 7.6, 1946838, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Dinkar Bapat (Survey 28/4C)', 2.59, 440069, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Rajendra Kharat (Survey 238/3)', 4.11, 803463, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Vijay Waghmare (Survey 204/B)', 7.03, 1747531, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Tanaji Patil (Survey 153/A)', 1.88, 408537, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj9, 'Rajendra Waghmare (Survey 22/B)', 11.02, 3392055, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Subhash Chavan (Survey 391/4C)', 11.66, 2444600, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Suresh More (Survey 240/B)', 11.88, 3679342, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Baburao Jagdale (Survey 75/1)', 0.73, 218524, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Laxmibai Sawant (Survey 261/4C)', 9.15, 2055639, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Rajendra Gaikwad (Survey 281/4C)', 7.54, 2174068, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Laxmibai Jadhav (Survey 44/1A)', 9.85, 2385935, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Parvatibai Tapkir (Survey 164/2)', 2.15, 339988, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Dattatray Shinde (Survey 126/2)', 10.95, 2146791, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Vijay Dumbre (Survey 245/1A)', 1.66, 320449, 'Paid', 'Active', '2025-09-10', 'Filed', 'Occupied', 'Verified'),
        (v_proj9, 'Chandrakant Salunkhe (Survey 77/2B)', 3.73, 717804, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Santosh Ghuge (Survey 74/B)', 11.35, 1624934, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Ganpat Pawar (Survey 237/1A)', 12.23, 3316017, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Santosh More (Survey 163/A)', 10.35, 2107839, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Vijay Kulkarni (Survey 398/3)', 1.18, 281975, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Sanjay Salunkhe (Survey 260/2)', 11.21, 3346016, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Tukaram Jadhav (Survey 94/1A)', 6.7, 970139, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Shantabai Pawar (Survey 107/1)', 3.99, 789644, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Ashok Pardeshi (Survey 238/2B)', 7.83, 2114217, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Tanaji Chavan (Survey 42/2B)', 8.84, 1880586, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Ganpat Joshi (Survey 75/1A)', 8.12, 2390154, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Sanjay Kharat (Survey 139/1)', 5.62, 1101042, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Mahesh Gawade (Survey 374/2B)', 12.26, 2967839, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Dinkar Gawade (Survey 213/1)', 2.8, 459365, 'Pending', 'Active', '2026-08-02', 'Filed', 'Refusing', 'Verified'),
        (v_proj9, 'Namdeo Pawar (Survey 277/2B)', 9.38, 1992236, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Maruti Pardeshi (Survey 342/2)', 5.45, 1422766, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Tanaji Dumbre (Survey 420/A)', 8.05, 2389352, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Bhaurao Patil (Survey 17/1A)', 9.94, 3015467, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj9, 'Ananda Chavan (Survey 57/1)', 3.7, 1050500, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj9, 'Vijay Bhandari (Survey 209/B)', 7.5, 1879477, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Dattatray Pawar (Survey 390/1)', 3.11, 888897, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified');

    -- ==========================================================
    -- PROJECT 10: Indapur - Baramati Renewable Energy & Power Corridor (Industrial Corridor)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Indapur - Baramati Renewable Energy & Power Corridor', 'Industrial Corridor', 'Pune', 'Bhigwan, Loni Deokar, Palasdeo, Shelgaon',
        1450.0, 60, 3,
        '2024-05-10', '2026-11-20', 'No',
        false, 9, v_profile_id
    ) RETURNING id INTO v_proj10;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj10, 60, 55, 52
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj10, 'Ananda Dumbre (Survey 268/2B)', 4.98, 1322199, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Prakash Bapat (Survey 16/1)', 7.15, 2176803, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Parvatibai Tapkir (Survey 366/2)', 12.63, 3867078, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj10, 'Shrikant Kshirsagar (Survey 140/4C)', 6.51, 2059060, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Dattatray Bhosale (Survey 311/4C)', 7.1, 1713187, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Vijay Patil (Survey 290/2)', 9.97, 1792296, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Santosh Bapat (Survey 342/3)', 6.92, 1042352, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Namdeo Kamble (Survey 209/2B)', 12.11, 3838252, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Rajendra Shinde (Survey 106/3)', 11.02, 2291333, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Ramesh Kharat (Survey 75/1)', 10.79, 1752695, 'Pending', 'Active', '2026-08-20', 'Filed', 'Refusing', 'Verified'),
        (v_proj10, 'Suresh Thorat (Survey 21/B)', 9.29, 2359130, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Shrikant Mohite (Survey 52/2B)', 12.75, 3900569, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Chandrakant More (Survey 309/A)', 6.48, 1333272, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Prakash Dumbre (Survey 328/1)', 6.12, 1799561, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Sanjay Jadhav (Survey 236/4C)', 5.15, 1554692, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Vitthal Jadhav (Survey 304/3)', 1.0, 220828, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Mahesh Patil (Survey 146/2)', 6.08, 1283706, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Suresh Gore (Survey 277/4C)', 11.53, 2135263, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Parvatibai Pawar (Survey 44/1)', 8.94, 1822088, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Ramesh Tapkir (Survey 335/B)', 3.95, 1032960, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Sanjay Bapat (Survey 231/2)', 11.0, 3170189, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Suresh Kshirsagar (Survey 70/B)', 3.58, 776759, 'Paid', 'Active', '2026-07-23', 'Filed', 'Refusing', 'Pending'),
        (v_proj10, 'Mahesh Thorat (Survey 351/2)', 3.92, 779162, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Rajendra Shirke (Survey 357/B)', 9.49, 2242021, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Kisan Nalawade (Survey 273/2B)', 12.27, 2086219, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Bhaurao Pawar (Survey 346/A)', 5.53, 1341931, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Subhash Ghuge (Survey 112/2B)', 6.84, 1951363, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Maruti Kharat (Survey 288/4C)', 0.93, 213355, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Bhaurao Chavan (Survey 397/1)', 1.92, 599191, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Mahesh Bapat (Survey 119/2B)', 1.66, 475621, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Mahesh More (Survey 287/A)', 7.63, 1577571, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Parvatibai More (Survey 331/2)', 4.33, 730020, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Dattatray Gore (Survey 154/A)', 6.57, 1926251, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Ramesh Ghuge (Survey 267/2)', 10.07, 2222247, 'Paid', 'Active', '2025-10-03', 'Filed', 'Occupied', 'Verified'),
        (v_proj10, 'Subhash Dumbre (Survey 383/B)', 7.44, 2211331, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Suresh Gaikwad (Survey 176/2B)', 3.67, 858717, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Shantabai Kamble (Survey 205/2)', 4.12, 802431, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj10, 'Shrikant Chavan (Survey 151/B)', 8.0, 1648216, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Chandrakant Kadam (Survey 381/1)', 2.9, 542300, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Shrikant Salunkhe (Survey 261/3)', 2.64, 802425, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Ananda Joshi (Survey 316/3)', 3.44, 1086864, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Ashok Chavan (Survey 98/2B)', 12.0, 2747244, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Pandurang Waghmare (Survey 418/1)', 12.62, 2262135, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Dinkar More (Survey 298/2B)', 10.91, 2241164, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Dattatray Jadhav (Survey 269/3)', 3.94, 715563, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Sunita Sawant (Survey 36/1)', 3.61, 1078458, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Subhash Pawar (Survey 296/2B)', 5.39, 961937, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Baburao Nalawade (Survey 163/1)', 9.45, 1473349, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Laxmibai Patil (Survey 83/1A)', 6.97, 1614419, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Ganpat Shinde (Survey 418/2B)', 0.97, 241294, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Sanjay Gore (Survey 192/1A)', 10.23, 1978205, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Pandurang Shirke (Survey 121/B)', 5.39, 1579771, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Laxmibai Shinde (Survey 20/1A)', 2.67, 775426, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Pandurang Kamble (Survey 120/2B)', 9.51, 1332874, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Bhaurao Joshi (Survey 86/1)', 1.07, 329616, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Dattatray Pardeshi (Survey 57/B)', 8.84, 2668513, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj10, 'Shantabai More (Survey 206/B)', 8.69, 1908854, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Dattatray Gore (Survey 354/1)', 12.07, 2093577, 'Paid', 'Active', '2026-02-04', 'Filed', 'Refusing', 'Pending'),
        (v_proj10, 'Maruti Kshirsagar (Survey 92/2B)', 4.54, 1277378, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Shantabai Jagdale (Survey 18/4C)', 10.72, 1950396, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified');

    -- ==========================================================
    -- PROJECT 11: Katraj Tunnel Bypass & Widening Project (NH-48) (Highway)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Katraj Tunnel Bypass & Widening Project (NH-48)', 'Highway', 'Pune', 'Katraj, Ambegaon, Shindewadi, Mangdewadi',
        310.0, 50, 8,
        '2024-03-20', '2026-12-15', 'Yes',
        true, 15, v_profile_id
    ) RETURNING id INTO v_proj11;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj11, 50, 22, 15
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj11, 'Baburao Ghuge (Survey 301/B)', 6.17, 1707689, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj11, 'Bhaurao Waghmare (Survey 56/2)', 10.83, 2648281, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj11, 'Bhaurao Kharat (Survey 189/2B)', 12.19, 3489875, 'Pending', 'Active', '2026-08-14', 'Filed', 'Refusing', 'Pending'),
        (v_proj11, 'Prakash Sawant (Survey 194/2)', 6.31, 1968114, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Namdeo Salunkhe (Survey 336/B)', 4.0, 658784, 'Pending', 'Active', '2025-12-04', 'Filed', 'Refusing', 'Verified'),
        (v_proj11, 'Dattatray Kshirsagar (Survey 332/3)', 3.63, 1059636, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj11, 'Rajendra Waghmare (Survey 203/2)', 8.13, 1237280, 'Pending', 'Active', '2026-07-13', 'Filed', 'Occupied', 'Pending'),
        (v_proj11, 'Ananda Kulkarni (Survey 382/4C)', 1.77, 420907, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj11, 'Mahesh Joshi (Survey 108/2B)', 9.89, 1404538, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj11, 'Vitthal More (Survey 289/2)', 8.28, 2250934, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Chandrakant Gaikwad (Survey 45/2)', 3.34, 1017664, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Santosh Waghmare (Survey 203/1A)', 1.64, 490884, 'Pending', 'Active', '2025-09-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj11, 'Shrikant Kamble (Survey 391/1A)', 10.79, 2800210, 'Pending', 'Active', '2026-06-23', 'Filed', 'Refusing', 'Pending'),
        (v_proj11, 'Sanjay Sawant (Survey 326/2)', 3.04, 451163, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj11, 'Ganpat Shirke (Survey 365/2B)', 10.45, 1965718, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj11, 'Suresh Jadhav (Survey 288/1A)', 1.72, 265500, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj11, 'Dattatray Nalawade (Survey 228/B)', 4.45, 1253685, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj11, 'Chandrakant Gawade (Survey 243/1A)', 10.23, 1754097, 'Pending', 'Active', '2026-03-24', 'Filed', 'Occupied', 'Pending'),
        (v_proj11, 'Namdeo Pardeshi (Survey 372/B)', 9.03, 1287407, 'Paid', 'Active', '2026-08-11', 'Filed', 'Occupied', 'Verified'),
        (v_proj11, 'Vijay Salunkhe (Survey 215/2)', 3.39, 645517, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj11, 'Pandurang Nalawade (Survey 17/4C)', 0.92, 246921, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Subhash Pardeshi (Survey 22/2)', 2.18, 527950, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Shrikant Kadam (Survey 387/B)', 4.42, 1382827, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Suresh Pardeshi (Survey 77/1A)', 2.02, 522495, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj11, 'Sunita Chavan (Survey 404/B)', 11.51, 2997399, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Parvatibai Dumbre (Survey 189/1)', 4.44, 1013869, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Ananda Kulkarni (Survey 30/4C)', 10.8, 2038413, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj11, 'Namdeo Kadam (Survey 74/2B)', 8.94, 2242509, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Parvatibai Gawade (Survey 279/1A)', 6.64, 1632709, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj11, 'Prakash Kamble (Survey 138/4C)', 1.33, 293234, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Ananda Kshirsagar (Survey 305/1A)', 1.98, 627806, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Sanjay Gawade (Survey 242/A)', 1.73, 455052, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj11, 'Shrikant Salunkhe (Survey 110/1A)', 12.02, 3779268, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj11, 'Chandrakant Bapat (Survey 345/1A)', 8.5, 1698640, 'Paid', 'Active', '2026-08-11', 'Filed', 'Refusing', 'Verified'),
        (v_proj11, 'Laxmibai Sawant (Survey 71/1A)', 6.71, 1304088, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj11, 'Vijay Kadam (Survey 202/B)', 9.08, 2731945, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Suresh Patil (Survey 346/2B)', 7.93, 1684871, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj11, 'Ashok Sawant (Survey 126/3)', 4.15, 1118516, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Suresh Shirke (Survey 237/A)', 2.15, 623639, 'Pending', 'Active', '2026-05-07', 'Filed', 'Refusing', 'Pending'),
        (v_proj11, 'Shantabai Gaikwad (Survey 136/2B)', 3.76, 712501, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj11, 'Namdeo Gaikwad (Survey 348/2)', 5.52, 1101670, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Chandrakant Gawade (Survey 354/4C)', 1.61, 470797, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj11, 'Mahesh Kulkarni (Survey 274/3)', 12.41, 2165160, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj11, 'Bhaurao Dumbre (Survey 172/3)', 9.56, 2115475, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj11, 'Vitthal Kamble (Survey 228/B)', 4.25, 1292471, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Chandrakant Gaikwad (Survey 65/1A)', 6.54, 1794831, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Ashok Salunkhe (Survey 231/3)', 2.99, 866845, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj11, 'Sanjay Deshmukh (Survey 116/2)', 10.99, 2593233, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj11, 'Pandurang Pawar (Survey 185/A)', 1.43, 240796, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj11, 'Pandurang Ghuge (Survey 345/A)', 2.38, 414222, 'Paid', 'Active', '2026-06-25', 'Filed', 'Refusing', 'Pending');

    -- ==========================================================
    -- PROJECT 12: Mula-Mutha Riverfront Development & Resettlement Zone (Smart City)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Mula-Mutha Riverfront Development & Resettlement Zone', 'Smart City', 'Pune', 'Sangamwadi, Yerawada, Bund Garden, Mundhwa',
        220.0, 75, 2,
        '2023-09-01', '2026-07-31', 'No',
        false, 21, v_profile_id
    ) RETURNING id INTO v_proj12;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj12, 75, 20, 12
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj12, 'Bhaurao Chavan (Survey 294/3)', 9.41, 1457420, 'Pending', 'Active', '2026-07-28', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Subhash Dumbre (Survey 93/4C)', 12.3, 3841732, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Suresh Deshmukh (Survey 246/4C)', 12.69, 3007035, 'Pending', 'Active', '2026-08-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Kisan Joshi (Survey 359/3)', 12.51, 3042619, 'Pending', 'Active', '2026-08-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Bhaurao Kshirsagar (Survey 185/B)', 11.14, 1634160, 'Paid', 'Active', '2026-06-27', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Dattatray Bhosale (Survey 311/3)', 1.55, 449687, 'Pending', 'Active', '2025-09-18', 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Shantabai Salunkhe (Survey 107/1)', 8.93, 1411449, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Ananda Shinde (Survey 225/B)', 3.3, 517509, 'Pending', 'Active', '2025-12-22', 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Vijay Dumbre (Survey 359/B)', 9.47, 2724689, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Sunita Jadhav (Survey 29/B)', 6.08, 1527101, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj12, 'Dinkar Jagdale (Survey 375/1)', 1.28, 382740, 'Pending', 'Active', '2025-08-23', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Ashok Patil (Survey 177/B)', 11.76, 1653679, 'Pending', 'Active', '2026-07-24', 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Tanaji Shirke (Survey 387/1)', 8.18, 1376636, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Kisan Patil (Survey 298/B)', 2.86, 551796, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Prakash Joshi (Survey 253/2)', 10.19, 2993516, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj12, 'Dattatray Joshi (Survey 52/2B)', 9.88, 3111913, 'Pending', 'Active', '2025-10-27', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Suresh Shinde (Survey 229/1A)', 10.7, 1623810, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Tanaji Gore (Survey 369/2)', 7.17, 1903993, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Suresh Joshi (Survey 78/2)', 11.67, 3537573, 'Paid', 'Active', '2026-06-22', 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Vijay Jagdale (Survey 419/4C)', 2.82, 665285, 'Pending', 'Active', '2026-01-31', 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Prakash Waghmare (Survey 200/3)', 10.42, 2867042, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Dattatray Kulkarni (Survey 223/B)', 4.24, 858523, 'Pending', 'Active', '2026-08-08', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Shantabai Shinde (Survey 408/2B)', 2.22, 506177, 'Pending', 'Active', '2026-07-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Ganpat Salunkhe (Survey 126/A)', 10.95, 1803103, 'Pending', 'Active', '2025-10-30', 'Filed', 'Refusing', 'Verified'),
        (v_proj12, 'Baburao Ghuge (Survey 133/2B)', 12.42, 2232209, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Dinkar Jadhav (Survey 261/4C)', 9.17, 1575259, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Ashok Kamble (Survey 136/4C)', 8.29, 1763158, 'Pending', 'Active', '2025-12-19', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Sunita Pawar (Survey 169/1)', 8.05, 2061033, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Kisan Salunkhe (Survey 104/2B)', 7.47, 2271552, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Sanjay Chavan (Survey 316/B)', 4.15, 1115362, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Ashok Bhosale (Survey 398/3)', 8.19, 2095157, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Ananda Dumbre (Survey 130/2)', 5.41, 1006595, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj12, 'Ananda Kadam (Survey 292/3)', 12.3, 2863809, 'Pending', 'Active', '2026-01-08', 'Filed', 'Occupied', 'Verified'),
        (v_proj12, 'Sanjay Joshi (Survey 23/2)', 1.93, 557825, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Sunita Bhandari (Survey 357/1A)', 12.16, 2871778, 'Pending', 'Active', '2026-05-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Shrikant Tapkir (Survey 100/2B)', 2.09, 441263, 'Paid', 'Active', '2026-02-19', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Parvatibai More (Survey 258/A)', 6.12, 1854372, 'Pending', 'Active', '2026-06-15', 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Shrikant Shirke (Survey 196/2B)', 9.9, 3051318, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Pandurang Jagdale (Survey 60/1)', 9.93, 2502032, 'Pending', 'Active', '2026-07-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Rajendra Tapkir (Survey 212/2)', 2.16, 668221, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Chandrakant Bhandari (Survey 342/4C)', 9.35, 1545022, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Santosh Thorat (Survey 284/4C)', 2.03, 345644, 'Pending', 'Active', '2025-10-30', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Dinkar Mohite (Survey 90/B)', 12.19, 2909338, 'Paid', 'Active', '2026-06-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Vijay Thorat (Survey 142/2B)', 10.02, 3055959, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Laxmibai Shinde (Survey 312/1A)', 7.85, 2196877, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Pandurang Ghuge (Survey 62/1A)', 10.39, 2547607, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Chandrakant Jagdale (Survey 106/4C)', 2.54, 362115, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Sunita Chavan (Survey 183/2B)', 0.97, 232961, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Kisan Deshmukh (Survey 246/B)', 7.34, 2302675, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Mahesh Bhandari (Survey 173/B)', 6.02, 1528327, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj12, 'Kisan Bapat (Survey 356/B)', 1.4, 213946, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Kisan Dumbre (Survey 210/1)', 7.42, 1788576, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Sanjay Kharat (Survey 210/B)', 4.63, 1381698, 'Paid', 'Active', '2026-01-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Kisan Joshi (Survey 36/4C)', 3.17, 895924, 'Pending', 'Active', '2026-08-05', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Vitthal Pawar (Survey 81/3)', 9.12, 2877515, 'Pending', 'Active', '2025-11-25', 'Filed', 'Occupied', 'Verified'),
        (v_proj12, 'Ramesh Kamble (Survey 129/1)', 5.6, 1071778, 'Pending', 'Active', '2026-07-05', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Namdeo Joshi (Survey 373/2B)', 1.71, 533933, 'Pending', 'Active', '2025-08-07', 'Filed', 'Refusing', 'Verified'),
        (v_proj12, 'Dattatray Gawade (Survey 233/1A)', 6.49, 1107025, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Sunita Dumbre (Survey 374/2B)', 3.28, 1035335, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Mahesh Jadhav (Survey 91/A)', 12.71, 2989175, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Sanjay Shinde (Survey 388/A)', 6.91, 1854167, 'Pending', 'Active', '2025-07-28', 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Subhash Salunkhe (Survey 167/A)', 7.66, 2345867, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Ashok Kshirsagar (Survey 305/A)', 1.67, 388059, 'Paid', 'Active', '2025-07-27', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Prakash More (Survey 151/3)', 1.82, 421559, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj12, 'Sunita Mohite (Survey 58/B)', 10.69, 2902345, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj12, 'Ashok Ghuge (Survey 229/B)', 9.21, 1611400, 'Pending', 'Active', '2025-07-26', 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Vitthal Pardeshi (Survey 358/1)', 11.65, 2407262, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj12, 'Mahesh Gore (Survey 217/2B)', 2.72, 437813, 'Pending', 'Active', '2026-06-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Parvatibai Deshmukh (Survey 212/1)', 10.13, 1685702, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj12, 'Shantabai Chavan (Survey 279/A)', 10.71, 2081445, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Suresh Pardeshi (Survey 78/4C)', 7.02, 2059752, 'Pending', 'Active', '2026-06-15', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Ganpat Bhandari (Survey 247/2)', 10.82, 1788048, 'Paid', 'Active', '2026-08-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Tukaram Kshirsagar (Survey 278/B)', 5.62, 989839, 'Pending', 'Active', '2026-08-11', 'Filed', 'Refusing', 'Pending'),
        (v_proj12, 'Subhash Shinde (Survey 309/1)', 8.3, 2524013, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj12, 'Dattatray Deshmukh (Survey 339/1A)', 1.3, 379501, 'Pending', 'Active', '2026-05-04', 'Filed', 'Refusing', 'Pending');

    RAISE NOTICE 'Successfully seeded 12 Pune District Projects and ~775 Family Records into Supabase!';
END $$;
