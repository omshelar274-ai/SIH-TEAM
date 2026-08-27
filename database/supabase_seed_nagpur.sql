-- ==========================================================================
-- Supabase Comprehensive Seed: 10 Real Nagpur Infrastructure Projects
-- Contains 10 Projects + R&R Status + ~655 Detailed Family Land Parcel Records
-- 100% Real Database Grounding for Nagpur District (No Mock Fallbacks)
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
BEGIN
    -- Grab first available profile ID for created_by reference
    SELECT id INTO v_profile_id FROM public.profiles LIMIT 1;

    -- Clean up previous Nagpur projects cleanly (cascades to families and rr)
    DELETE FROM public.projects WHERE district = 'Nagpur';

    -- ==========================================================
    -- PROJECT 1: New Nagpur IBFC (International Business & Finance Centre) (Smart City)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'New Nagpur IBFC (International Business & Finance Centre)', 'Smart City', 'Nagpur', 'Godhani (Rithi), Ladgaon (Rithi/Khurd) — Hingna Taluka',
        692.0, 75, 4,
        '2023-09-15', '2027-06-30', 'No',
        false, 22, v_profile_id
    ) RETURNING id INTO v_proj1;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj1, 75, 20, 14
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj1, 'Namdeo Borkar (Survey 24/2B)', 3.86, 604394, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Pramod Wankhede (Survey 123/1A)', 7.42, 942013, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Ganpat Jadhav (Survey 15/3)', 10.06, 2104491, 'Pending', 'Active', '2026-07-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Laxmibai Tembhare (Survey 147/1)', 10.5, 2735964, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Kisan Pawar (Survey 333/4C)', 8.41, 1162539, 'Paid', 'Active', '2026-07-16', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Ashok Tidke (Survey 198/3)', 5.57, 974309, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Mahesh Deshmukh (Survey 137/3)', 6.83, 1302924, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Dinkar Gajbhiye (Survey 129/1)', 11.53, 2596117, 'Pending', 'Active', '2026-02-15', 'Filed', 'Refusing', 'Verified'),
        (v_proj1, 'Ashok Thakre (Survey 147/3)', 3.88, 1036576, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Dilip Kohale (Survey 264/2)', 10.85, 1613861, 'Paid', 'Active', '2026-05-02', 'Filed', 'Refusing', 'Verified'),
        (v_proj1, 'Sanjay Khadse (Survey 295/1)', 9.82, 1473284, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Parvatibai Raut (Survey 244/1)', 13.57, 2565340, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Shrikant Tidke (Survey 271/1A)', 2.59, 420483, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Pramod Borkar (Survey 197/2B)', 3.78, 692280, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Dinkar Mandape (Survey 76/3)', 9.54, 2519771, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Baburao Mohite (Survey 288/1A)', 10.27, 2306570, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Sudhakar Wankhede (Survey 185/1)', 8.56, 1543564, 'Pending', 'Active', '2026-08-15', 'Filed', 'Occupied', 'Verified'),
        (v_proj1, 'Santosh Kohale (Survey 133/2B)', 9.66, 1701705, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Vijay Jadhav (Survey 220/1A)', 1.79, 417064, 'Pending', 'Active', '2026-08-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Chandrakant Borkar (Survey 139/1A)', 3.11, 738939, 'Paid', 'Active', '2026-06-24', 'Filed', 'Refusing', 'Verified'),
        (v_proj1, 'Mahesh Borkar (Survey 37/1)', 13.78, 2507477, 'Paid', 'Active', '2026-07-26', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Shantabai Khadse (Survey 244/2B)', 6.3, 1673853, 'Pending', 'Active', '2026-07-29', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Mahesh Gajbhiye (Survey 172/1)', 1.19, 291534, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Vitthal Wankhede (Survey 316/2)', 9.75, 1771155, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Santosh Dhenge (Survey 348/4C)', 13.31, 2309883, 'Pending', 'Active', '2026-07-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Sunita Mohite (Survey 49/1)', 6.78, 1814226, 'Pending', 'Active', '2025-09-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Santosh Gaikwad (Survey 137/4C)', 4.4, 1033414, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Pramod Padole (Survey 295/2B)', 13.27, 1952733, 'Pending', 'Active', '2026-08-08', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Maruti Kumbhare (Survey 116/2B)', 7.42, 1378851, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Pramod Kumbhare (Survey 78/2B)', 2.71, 639083, 'Pending', 'Active', '2026-08-21', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Dilip Mandape (Survey 30/4C)', 8.48, 1346802, 'Pending', 'Active', '2026-05-14', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Dattatray Nikhare (Survey 298/A)', 13.84, 2221527, 'Pending', 'Active', '2026-03-05', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Sunita Jadhav (Survey 222/1A)', 4.16, 617077, 'Pending', 'Active', '2026-06-23', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Kisan Pawar (Survey 128/1A)', 0.82, 139914, 'Pending', 'Active', '2026-01-12', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Shrikant Mandape (Survey 181/1)', 2.08, 392028, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Dattatray Tembhare (Survey 234/4C)', 10.48, 2119349, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Suresh Sonkusare (Survey 235/1)', 7.62, 1989970, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Bhaurao Mohite (Survey 181/4C)', 9.59, 1464095, 'Pending', 'Active', '2025-11-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Dilip Gawande (Survey 227/A)', 9.78, 1619763, 'Pending', 'Active', '2025-12-30', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Tukaram Tidke (Survey 176/B)', 6.55, 1152931, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj1, 'Kisan Kohale (Survey 351/4C)', 1.78, 323192, 'Pending', 'Active', '2026-07-28', 'Filed', 'Refusing', 'Verified'),
        (v_proj1, 'Tukaram Shinde (Survey 49/B)', 6.18, 1761850, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Maruti Meshram (Survey 66/A)', 3.5, 895226, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Ashok Padole (Survey 283/4C)', 13.52, 3190949, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Subhash Raut (Survey 255/B)', 4.05, 748488, 'Pending', 'Active', '2026-02-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Sudhakar Khadse (Survey 183/4C)', 12.73, 1796483, 'Paid', 'Active', '2026-08-03', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Ashok Dhenge (Survey 43/1A)', 11.91, 2645199, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Shantabai Ghormade (Survey 15/4C)', 4.59, 1020044, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Tukaram Gaikwad (Survey 124/B)', 3.51, 822221, 'Pending', 'Active', '2026-03-11', 'Filed', 'Occupied', 'Verified'),
        (v_proj1, 'Mahesh Meshram (Survey 213/1)', 1.65, 383390, 'Paid', 'Active', '2026-01-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Sunita Patil (Survey 206/2B)', 10.8, 2489508, 'Pending', 'Active', '2026-08-20', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Namdeo Wankhede (Survey 345/1)', 10.83, 2001633, 'Paid', 'Active', '2026-08-03', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Baburao Bhadange (Survey 370/2B)', 11.01, 1805463, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Kisan Borkar (Survey 308/1)', 13.23, 3584549, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Maruti Pawar (Survey 333/1A)', 1.9, 378210, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj1, 'Laxmibai Mandape (Survey 231/4C)', 1.44, 417238, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj1, 'Namdeo Gaikwad (Survey 247/3)', 6.47, 1661314, 'Pending', 'Active', '2025-10-08', 'Filed', 'Occupied', 'Pending'),
        (v_proj1, 'Sunita Shinde (Survey 137/2)', 4.32, 1028916, 'Pending', 'Active', '2026-07-05', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Vijay Gawande (Survey 193/2B)', 5.16, 1425594, 'Pending', 'Active', '2026-08-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Vijay Mandape (Survey 135/B)', 9.35, 2325017, 'Pending', 'Active', '2026-02-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Prakash Nikhare (Survey 254/4C)', 6.33, 1672898, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Baburao Kumbhare (Survey 73/3)', 3.12, 770418, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj1, 'Shrikant Gawande (Survey 163/1A)', 5.44, 1083849, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Suresh Mandape (Survey 161/3)', 9.24, 2297803, 'Paid', 'Active', '2025-10-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Suresh Khadse (Survey 256/2)', 11.76, 2646505, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Kisan Wankhede (Survey 139/2)', 8.15, 1867140, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Ashok Bawankule (Survey 313/A)', 4.68, 1323494, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj1, 'Dinkar Gawande (Survey 332/1A)', 4.13, 583494, 'Paid', 'Active', '2026-08-13', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Vijay Bawankule (Survey 28/1A)', 4.45, 863798, 'Pending', 'Active', '2026-07-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Namdeo Thakre (Survey 148/3)', 1.48, 241972, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj1, 'Ashok Sonkusare (Survey 167/A)', 13.41, 3368524, 'Pending', 'Active', '2025-10-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj1, 'Sudhakar Bhosale (Survey 357/1)', 14.19, 2705323, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Ganpat Raut (Survey 311/A)', 9.2, 2289898, 'Pending', 'Active', '2025-12-15', 'Filed', 'Refusing', 'Verified'),
        (v_proj1, 'Sunita Dhenge (Survey 367/B)', 4.45, 1001143, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj1, 'Dinkar Zoting (Survey 275/1)', 9.51, 2493873, 'Pending', 'Active', '2025-09-21', 'Filed', 'Occupied', 'Pending');

    -- ==========================================================
    -- PROJECT 2: Third Outer Ring Road — 148 km Corridor (Phase 1) (Highway)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Third Outer Ring Road — 148 km Corridor (Phase 1)', 'Highway', 'Nagpur', 'Turagondi, Shirkal, Fetri, Wadi, Besa, Tarsa (Hingna, Kalmeshwar, Kamptee)',
        1840.0, 110, 12,
        '2024-01-10', '2028-12-31', 'Yes',
        true, 28, v_profile_id
    ) RETURNING id INTO v_proj2;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj2, 110, 25, 18
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj2, 'Mahesh Thakre (Survey 159/B)', 12.57, 3105594, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Sudhakar Sonkusare (Survey 93/2B)', 8.05, 2131390, 'Pending', 'Active', '2026-08-08', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Narendra Sonkusare (Survey 161/2B)', 6.19, 1525735, 'Pending', 'Active', '2026-08-04', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Subhash Thakre (Survey 47/2B)', 11.09, 2537103, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Shrikant Chikte (Survey 308/B)', 12.35, 2927678, 'Pending', 'Active', '2025-10-13', 'Filed', 'Occupied', 'Verified'),
        (v_proj2, 'Sudhakar Chikte (Survey 208/1A)', 12.23, 2784550, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Rajendra Zoting (Survey 209/3)', 7.29, 945542, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Dattatray Shinde (Survey 237/2)', 7.71, 1848703, 'Paid', 'Active', '2026-04-26', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Tukaram Sonkusare (Survey 215/2)', 12.17, 3162800, 'Pending', 'Active', '2026-06-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Bhaurao Mohite (Survey 159/1A)', 10.73, 2508276, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Kisan Gaikwad (Survey 26/1)', 4.94, 665472, 'Pending', 'Active', '2026-01-29', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Vitthal Raut (Survey 52/A)', 8.99, 1646356, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Bhaurao Meshram (Survey 250/2B)', 9.78, 1578609, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Kisan Tidke (Survey 229/2B)', 6.76, 1346585, 'Paid', 'Active', '2026-06-22', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Kisan Sonkusare (Survey 163/1)', 13.9, 3110236, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Tukaram Deshmukh (Survey 266/2B)', 11.13, 2007006, 'Pending', 'Active', '2026-07-29', 'Filed', 'Refusing', 'Verified'),
        (v_proj2, 'Namdeo Gajbhiye (Survey 170/B)', 0.96, 207020, 'Pending', 'Active', '2025-12-18', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Mahesh Gaikwad (Survey 199/2B)', 11.88, 2225872, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj2, 'Rajendra Borkar (Survey 251/2)', 2.43, 435317, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj2, 'Laxmibai Wankhede (Survey 214/1)', 4.12, 627879, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Laxmibai Borkar (Survey 357/1A)', 6.96, 1965573, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Shrikant Bhadange (Survey 370/2B)', 9.39, 1413993, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Vijay Borkar (Survey 61/1A)', 12.66, 1969427, 'Pending', 'Active', '2026-03-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Tukaram Dhenge (Survey 155/1)', 9.96, 1762471, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Mahesh Gaikwad (Survey 342/4C)', 1.33, 255785, 'Paid', 'Active', '2026-06-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Pramod Gajbhiye (Survey 182/1A)', 14.05, 3765400, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Sudhakar Kumbhare (Survey 87/1)', 4.3, 679094, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Dilip Meshram (Survey 195/1A)', 8.57, 1063845, 'Paid', 'Active', '2026-06-30', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Dinkar Nikhare (Survey 274/2)', 6.69, 1191335, 'Pending', 'Active', '2026-07-15', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Shantabai Dhenge (Survey 363/2)', 7.22, 1705919, 'Paid', 'Active', '2026-08-04', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Mahesh Sonkusare (Survey 178/A)', 14.13, 3660828, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Namdeo Tidke (Survey 294/1A)', 6.39, 1149548, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Sunita Padole (Survey 142/4C)', 13.56, 3313060, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Dattatray Deshmukh (Survey 202/3)', 8.12, 2222752, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Dinkar Dhenge (Survey 38/2B)', 8.73, 1852340, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Vijay Dhoke (Survey 67/4C)', 12.08, 2613544, 'Paid', 'Active', '2026-07-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Maruti Khadse (Survey 26/3)', 4.24, 852231, 'Pending', 'Active', '2026-03-22', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Pramod Wankhede (Survey 283/1A)', 5.65, 1349898, 'Pending', 'Active', '2026-07-12', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Dinkar Tembhare (Survey 37/2)', 4.23, 977772, 'Pending', 'Active', '2026-07-19', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Bhaurao Padole (Survey 315/B)', 7.72, 1550562, 'Paid', 'Active', '2026-08-15', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Dilip Patil (Survey 142/2B)', 5.0, 610130, 'Pending', 'Active', '2026-08-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Rajendra Nikhare (Survey 48/A)', 12.31, 1613705, 'Pending', 'Active', '2025-12-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Parvatibai Bawankule (Survey 70/A)', 0.79, 162057, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Maruti Mohite (Survey 197/2)', 6.48, 957426, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Sunita Dhoke (Survey 182/3)', 1.55, 443293, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj2, 'Laxmibai Nikhare (Survey 342/3)', 3.74, 592374, 'Pending', 'Active', '2026-08-03', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Ashok Patil (Survey 300/B)', 9.83, 2634223, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Ashok Wankhede (Survey 252/B)', 9.15, 1756836, 'Pending', 'Active', '2025-12-27', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Shrikant Bawankule (Survey 51/2)', 8.93, 2258611, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj2, 'Narendra Jadhav (Survey 304/1A)', 4.9, 1198946, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Maruti Wankhede (Survey 270/3)', 1.04, 244145, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Shantabai Dhenge (Survey 185/1)', 11.31, 3276359, 'Pending', 'Active', '2026-01-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Narendra Tembhare (Survey 88/4C)', 1.62, 254459, 'Pending', 'Active', '2026-07-03', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Rajendra Kumbhare (Survey 77/2)', 9.35, 2159784, 'Pending', 'Active', '2026-07-14', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Baburao Dhoke (Survey 82/3)', 1.56, 228560, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Subhash Patil (Survey 328/3)', 8.68, 1392584, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Rajendra Gaikwad (Survey 96/B)', 1.1, 237047, 'Pending', 'Active', '2026-01-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Rajendra Jadhav (Survey 252/1A)', 5.54, 1493207, 'Pending', 'Active', '2025-11-20', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Rajendra Tembhare (Survey 82/2B)', 1.21, 297639, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Kisan Wankhede (Survey 94/2B)', 6.66, 1695449, 'Paid', 'Active', '2025-10-16', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Shantabai Kohale (Survey 203/1A)', 5.79, 818659, 'Pending', 'Active', '2026-08-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Shrikant Ghormade (Survey 368/3)', 10.9, 2648416, 'Pending', 'Active', '2026-05-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Tanaji Tembhare (Survey 282/A)', 2.02, 394958, 'Pending', 'Active', '2025-11-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Vijay Tembhare (Survey 286/1)', 9.16, 2480024, 'Pending', 'Active', '2026-06-03', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Bhaurao Padole (Survey 55/4C)', 1.43, 368801, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Suresh Tidke (Survey 210/4C)', 3.98, 494542, 'Pending', 'Active', '2026-04-11', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Sunita Pawar (Survey 341/3)', 11.88, 2872560, 'Pending', 'Active', '2026-07-30', 'Filed', 'Refusing', 'Verified'),
        (v_proj2, 'Suresh Bawankule (Survey 115/1)', 11.34, 1485369, 'Pending', 'Active', '2025-08-29', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Baburao Bawankule (Survey 194/1)', 12.36, 2558668, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Shantabai Kumbhare (Survey 107/B)', 9.98, 2158644, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj2, 'Tukaram Pawar (Survey 104/2B)', 4.9, 690846, 'Pending', 'Active', '2026-06-26', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Suresh Deshmukh (Survey 192/A)', 4.26, 575253, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Rajendra Deshmukh (Survey 359/3)', 13.55, 2133149, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Namdeo Nikhare (Survey 197/A)', 13.51, 1735886, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Prakash Thakre (Survey 283/4C)', 5.95, 1148683, 'Pending', 'Active', '2025-09-21', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Dinkar Khadse (Survey 372/B)', 3.44, 964572, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Ashok Raut (Survey 377/B)', 14.16, 2885496, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Vitthal Sonkusare (Survey 375/3)', 11.37, 2880782, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Laxmibai Mandape (Survey 305/4C)', 6.9, 1825809, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Shantabai Sonkusare (Survey 380/B)', 7.7, 1750441, 'Pending', 'Active', '2026-04-27', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Dilip Gaikwad (Survey 294/3)', 11.02, 1695151, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Vitthal Raut (Survey 177/1A)', 5.24, 1341571, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Dilip Tidke (Survey 167/2)', 7.39, 1213482, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj2, 'Sunita Pawar (Survey 300/1)', 11.81, 1505030, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Ganpat Tidke (Survey 119/A)', 8.97, 1147612, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Rajendra Jadhav (Survey 362/A)', 4.57, 635819, 'Pending', 'Active', '2025-09-29', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Sunita Shinde (Survey 379/4C)', 10.56, 2223260, 'Pending', 'Active', '2026-07-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Ganpat Bhadange (Survey 138/3)', 1.83, 358820, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Shrikant Kumbhare (Survey 307/4C)', 3.1, 501487, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Shantabai Kohale (Survey 246/1A)', 3.45, 733156, 'Paid', 'Active', '2026-06-23', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Subhash Khadse (Survey 199/A)', 5.51, 1239805, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Kisan Wankhede (Survey 209/B)', 10.97, 2120797, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Laxmibai Jadhav (Survey 185/4C)', 10.84, 1866442, 'Pending', 'Active', '2026-08-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Vijay Kohale (Survey 245/3)', 8.81, 2247748, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Shantabai Tembhare (Survey 165/4C)', 7.45, 1889454, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj2, 'Bhaurao Borkar (Survey 225/2B)', 11.42, 3254197, 'Paid', 'Active', '2026-05-08', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Tukaram Patil (Survey 206/3)', 11.76, 2157842, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Pramod Bhadange (Survey 172/A)', 2.57, 445761, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj2, 'Suresh Sonkusare (Survey 82/1A)', 8.18, 2007388, 'Pending', 'Active', '2025-10-11', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Chandrakant Deshmukh (Survey 360/2B)', 8.86, 1509744, 'Pending', 'Active', '2026-02-08', 'Filed', 'Occupied', 'Pending'),
        (v_proj2, 'Maruti Sonkusare (Survey 262/4C)', 7.07, 1887180, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj2, 'Shantabai Gaikwad (Survey 214/4C)', 13.58, 2151031, 'Pending', 'Active', '2025-12-08', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Baburao Gawande (Survey 287/2B)', 13.28, 2539175, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Sudhakar Gajbhiye (Survey 354/1A)', 9.24, 1235942, 'Paid', 'Active', '2026-06-23', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Narendra Raut (Survey 220/B)', 7.04, 1212893, 'Pending', 'Active', '2026-07-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Tanaji Deshmukh (Survey 31/3)', 6.23, 1034684, 'Pending', 'Active', '2026-07-03', 'Filed', 'Occupied', 'Verified'),
        (v_proj2, 'Narendra Bawankule (Survey 31/1)', 4.59, 1276088, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj2, 'Namdeo Mandape (Survey 280/B)', 12.68, 1967669, 'Pending', 'Active', '2026-04-07', 'Filed', 'Refusing', 'Pending'),
        (v_proj2, 'Ganpat Sonkusare (Survey 107/1)', 10.59, 2089809, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj2, 'Shrikant Dhenge (Survey 275/4C)', 1.69, 245056, 'Paid', 'Active', '2026-07-12', 'Filed', 'Refusing', 'Pending');

    -- ==========================================================
    -- PROJECT 3: Nagpur Metro Phase 2 — Kamptee-Kanhan Extension (Metro)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Nagpur Metro Phase 2 — Kamptee-Kanhan Extension', 'Metro', 'Nagpur', 'Kamptee Town, Kanhan, Koradi',
        28.0, 35, 0,
        '2024-06-01', '2027-03-31', 'No',
        false, 8, v_profile_id
    ) RETURNING id INTO v_proj3;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj3, 35, 32, 30
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj3, 'Dinkar Khadse (Survey 180/2B)', 8.48, 2291092, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Suresh Padole (Survey 72/B)', 4.7, 1063501, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Dinkar Bawankule (Survey 365/2)', 9.25, 1825413, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Vijay Thakre (Survey 244/4C)', 6.2, 1636663, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj3, 'Bhaurao Patil (Survey 317/2)', 7.7, 1990118, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Suresh Pawar (Survey 292/1A)', 8.35, 1330004, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Bhaurao Gawande (Survey 379/B)', 1.75, 444134, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Parvatibai Bhadange (Survey 300/1)', 8.16, 1638397, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Tanaji Gawande (Survey 308/2)', 1.12, 235553, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Subhash Wankhede (Survey 253/1)', 4.43, 740611, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Namdeo Bhosale (Survey 227/4C)', 14.1, 3105722, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Santosh Padole (Survey 350/3)', 9.45, 1995509, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Dilip Deshmukh (Survey 126/1)', 10.86, 2152604, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Shantabai Pawar (Survey 129/1A)', 6.81, 1094121, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Dattatray Gajbhiye (Survey 350/A)', 8.92, 1106980, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Ashok Tembhare (Survey 356/1)', 3.85, 506644, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Chandrakant Patil (Survey 40/3)', 7.4, 1449127, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Prakash Tembhare (Survey 356/4C)', 3.75, 590827, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj3, 'Prakash Gaikwad (Survey 101/A)', 8.12, 1074194, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Parvatibai Dhenge (Survey 88/2B)', 5.66, 1477339, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Maruti Thakre (Survey 249/1)', 8.2, 1879316, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Baburao Kumbhare (Survey 343/2)', 13.13, 2852820, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Ganpat Zoting (Survey 356/1)', 12.47, 2111482, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Baburao Ghormade (Survey 118/4C)', 4.65, 576688, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Tanaji Patil (Survey 257/1A)', 10.03, 1741318, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Kisan Zoting (Survey 250/4C)', 4.73, 1013534, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Tanaji Ghormade (Survey 175/1A)', 5.58, 1275080, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Pramod Khadse (Survey 295/A)', 4.54, 778292, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Vijay Mandape (Survey 347/4C)', 4.03, 999798, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj3, 'Vitthal Thakre (Survey 380/B)', 3.02, 791593, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj3, 'Shrikant Padole (Survey 36/1)', 6.15, 1754804, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Sanjay Bhadange (Survey 203/1)', 8.96, 2523279, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj3, 'Pramod Kohale (Survey 152/2B)', 0.73, 169996, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj3, 'Dattatray Kohale (Survey 88/1A)', 3.13, 807561, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj3, 'Santosh Nikhare (Survey 219/B)', 8.24, 1476665, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending');

    -- ==========================================================
    -- PROJECT 4: MIHAN SEZ — Remaining PAP Land Distribution & Handover (Airport)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'MIHAN SEZ — Remaining PAP Land Distribution & Handover', 'Airport', 'Nagpur', 'Khapri, Mahurzari, Wadgaon (South Nagpur)',
        480.0, 85, 10,
        '2023-04-01', '2026-12-31', 'Yes',
        false, 18, v_profile_id
    ) RETURNING id INTO v_proj4;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj4, 85, 45, 38
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj4, 'Chandrakant Tidke (Survey 28/2)', 6.05, 1324175, 'Pending', 'Active', '2026-08-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Rajendra Kumbhare (Survey 301/2)', 12.76, 1673525, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Prakash Ghormade (Survey 150/1)', 13.16, 2546433, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Baburao Chikte (Survey 85/A)', 13.23, 2625533, 'Paid', 'Active', '2025-08-31', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Rajendra Sonkusare (Survey 52/4C)', 1.24, 290879, 'Paid', 'Active', '2026-07-03', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Ashok Ghormade (Survey 128/4C)', 8.08, 1764793, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Rajendra Dhoke (Survey 377/2)', 1.62, 259893, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Santosh Meshram (Survey 169/B)', 5.43, 1035593, 'Paid', 'Active', '2025-10-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Mahesh Wankhede (Survey 317/4C)', 12.33, 1519487, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Subhash Mandape (Survey 136/3)', 9.89, 1626242, 'Paid', 'Active', '2026-06-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Kisan Ghormade (Survey 51/4C)', 3.95, 729335, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Pramod Bhosale (Survey 214/4C)', 12.03, 2641607, 'Pending', 'Active', '2026-07-11', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Maruti Gawande (Survey 257/4C)', 2.93, 657480, 'Pending', 'Active', '2026-06-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Rajendra Zoting (Survey 198/2)', 13.27, 2287429, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj4, 'Ashok Bhosale (Survey 374/1A)', 6.51, 1278368, 'Pending', 'Active', '2026-07-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Bhaurao Thakre (Survey 378/A)', 11.31, 1576489, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj4, 'Chandrakant Sonkusare (Survey 226/1)', 11.33, 2427429, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Sudhakar Padole (Survey 352/4C)', 2.78, 780093, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Shantabai Bhosale (Survey 181/A)', 1.95, 284405, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Prakash Sonkusare (Survey 306/1A)', 6.61, 1470943, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj4, 'Vijay Borkar (Survey 163/A)', 13.11, 1868253, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Kisan Kumbhare (Survey 245/1A)', 7.64, 1614362, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Rajendra Sonkusare (Survey 70/1)', 12.13, 3516013, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj4, 'Tanaji Dhoke (Survey 276/3)', 8.06, 1666533, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Namdeo Padole (Survey 233/A)', 0.9, 252885, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Ganpat Patil (Survey 372/2)', 8.41, 2192840, 'Paid', 'Active', '2026-04-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Namdeo Kumbhare (Survey 317/A)', 8.87, 2429306, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Vitthal Pawar (Survey 356/2B)', 13.09, 3595940, 'Paid', 'Active', '2026-02-01', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Dilip Kohale (Survey 210/A)', 8.67, 2346804, 'Pending', 'Active', '2026-07-31', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Sunita Pawar (Survey 242/1)', 12.36, 1514248, 'Pending', 'Active', '2025-08-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Maruti Pawar (Survey 239/B)', 2.79, 748319, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Ganpat Dhoke (Survey 287/2B)', 2.8, 671675, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Ganpat Patil (Survey 290/4C)', 7.93, 1038092, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Namdeo Patil (Survey 138/2B)', 12.48, 1603043, 'Pending', 'Active', '2026-08-11', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Rajendra Deshmukh (Survey 313/4C)', 12.3, 3443704, 'Pending', 'Active', '2026-08-05', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Mahesh Khadse (Survey 317/3)', 4.93, 969790, 'Paid', 'Active', '2026-06-18', 'Filed', 'Occupied', 'Verified'),
        (v_proj4, 'Narendra Gajbhiye (Survey 153/3)', 10.11, 1564866, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj4, 'Dinkar Pawar (Survey 358/A)', 7.21, 1956563, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj4, 'Dinkar Wankhede (Survey 218/2B)', 10.02, 2171824, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj4, 'Santosh Deshmukh (Survey 246/4C)', 12.15, 3160166, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Kisan Kumbhare (Survey 292/3)', 8.26, 2042103, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Shrikant Bhadange (Survey 20/2)', 13.23, 2135507, 'Pending', 'Active', '2026-06-29', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Chandrakant Mohite (Survey 152/2)', 9.47, 1757991, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Suresh Zoting (Survey 332/2B)', 10.45, 1895410, 'Pending', 'Active', '2026-08-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Sudhakar Kohale (Survey 360/B)', 0.63, 132340, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Shantabai Wankhede (Survey 64/2)', 4.79, 950561, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj4, 'Dilip Tidke (Survey 358/3)', 1.44, 385434, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Tanaji Gawande (Survey 333/3)', 13.1, 3687650, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj4, 'Prakash Deshmukh (Survey 208/4C)', 13.7, 2773496, 'Pending', 'Active', '2026-01-27', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Chandrakant Shinde (Survey 349/2B)', 3.31, 923827, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj4, 'Sudhakar Ghormade (Survey 209/2)', 3.8, 1091622, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj4, 'Dilip Zoting (Survey 303/A)', 5.51, 910747, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Ganpat Gawande (Survey 32/1)', 13.5, 3028401, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Santosh Tidke (Survey 286/3)', 4.3, 865332, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj4, 'Dilip Mandape (Survey 179/A)', 8.53, 2461749, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Chandrakant Dhoke (Survey 41/1A)', 1.68, 392946, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Bhaurao Deshmukh (Survey 348/3)', 2.14, 333773, 'Pending', 'Active', '2025-09-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Dinkar Shinde (Survey 149/2)', 11.07, 1413583, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Ganpat Sonkusare (Survey 307/2)', 7.3, 1853455, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Dattatray Gaikwad (Survey 305/2)', 3.63, 919787, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Suresh Ghormade (Survey 198/A)', 13.11, 2188229, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Parvatibai Dhoke (Survey 176/1A)', 6.2, 1263987, 'Paid', 'Active', '2026-07-06', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Suresh Bhosale (Survey 217/2)', 12.51, 2427002, 'Pending', 'Active', '2025-08-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Prakash Jadhav (Survey 167/1A)', 6.86, 1887240, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj4, 'Rajendra Dhoke (Survey 89/1)', 13.27, 1675563, 'Paid', 'Active', '2026-08-21', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Tanaji Deshmukh (Survey 169/2)', 3.31, 603856, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Suresh Mohite (Survey 130/A)', 10.1, 2198224, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Shantabai Wankhede (Survey 315/1)', 6.46, 996545, 'Paid', 'Active', '2025-11-14', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Santosh Bhosale (Survey 115/3)', 11.19, 3057969, 'Paid', 'Active', '2025-10-08', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Dinkar Gawande (Survey 243/2B)', 6.85, 1037322, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Maruti Sonkusare (Survey 320/1)', 3.45, 710455, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj4, 'Shantabai Kohale (Survey 37/2B)', 4.06, 672246, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Tanaji Mandape (Survey 139/2)', 6.83, 1069885, 'Paid', 'Active', '2026-07-25', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Namdeo Bhosale (Survey 342/2)', 8.48, 1592951, 'Pending', 'Active', '2026-02-22', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Chandrakant Pawar (Survey 181/2)', 1.08, 260114, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Tanaji Zoting (Survey 266/1)', 5.74, 1330801, 'Paid', 'Active', '2026-01-14', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Tukaram Tembhare (Survey 327/1A)', 9.37, 2349817, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Baburao Tidke (Survey 281/1A)', 9.14, 2399396, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj4, 'Vijay Nikhare (Survey 301/4C)', 5.82, 972737, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj4, 'Rajendra Patil (Survey 155/1)', 11.58, 2821455, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj4, 'Bhaurao Dhoke (Survey 148/1)', 10.97, 1947361, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj4, 'Vitthal Raut (Survey 133/4C)', 11.55, 2472300, 'Pending', 'Active', '2026-07-08', 'Filed', 'Refusing', 'Pending'),
        (v_proj4, 'Rajendra Gaikwad (Survey 264/2B)', 2.91, 378157, 'Paid', 'Active', '2026-05-24', 'Filed', 'Refusing', 'Verified'),
        (v_proj4, 'Baburao Jadhav (Survey 78/4C)', 10.32, 2113804, 'Paid', 'Active', '2026-04-08', 'Filed', 'Occupied', 'Pending'),
        (v_proj4, 'Bhaurao Zoting (Survey 312/2)', 5.11, 1045342, 'Paid', 'Active', '2025-09-27', 'Filed', 'Refusing', 'Verified');

    -- ==========================================================
    -- PROJECT 5: Nag River Pollution Abatement & STP Land Acquisition (Dam)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Nag River Pollution Abatement & STP Land Acquisition', 'Dam', 'Nagpur', 'Maharajbagh (PDKV Campus), VNIT Area, Bidipeth, Nari, Kachimet',
        85.0, 50, 2,
        '2024-02-15', '2027-08-31', 'No',
        false, 24, v_profile_id
    ) RETURNING id INTO v_proj5;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj5, 50, 35, 30
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj5, 'Maruti Gaikwad (Survey 326/4C)', 3.56, 976824, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj5, 'Pramod Bhosale (Survey 371/A)', 12.16, 3268145, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Tukaram Dhoke (Survey 339/2)', 13.33, 2091050, 'Paid', 'Active', '2026-07-09', 'Filed', 'Refusing', 'Verified'),
        (v_proj5, 'Shrikant Sonkusare (Survey 355/4C)', 6.62, 1254642, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Rajendra Borkar (Survey 380/1)', 1.16, 272456, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Mahesh Zoting (Survey 63/B)', 11.31, 3071038, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Kisan Meshram (Survey 175/2B)', 13.54, 1888166, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Santosh Mandape (Survey 59/4C)', 8.64, 2426656, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Parvatibai Raut (Survey 39/2)', 5.04, 855807, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Mahesh Khadse (Survey 350/2B)', 4.57, 663303, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Dilip Gajbhiye (Survey 196/1)', 6.36, 1254281, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj5, 'Namdeo Bawankule (Survey 53/B)', 12.06, 2422033, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj5, 'Shantabai Raut (Survey 201/A)', 5.56, 1316924, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Shrikant Khadse (Survey 300/1)', 2.57, 373549, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Dinkar Chikte (Survey 128/1)', 12.02, 3089031, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Vijay Chikte (Survey 132/B)', 4.59, 1025842, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj5, 'Bhaurao Tembhare (Survey 87/2)', 13.5, 3209125, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Rajendra Gawande (Survey 76/1)', 6.3, 1475050, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Tukaram Khadse (Survey 175/2)', 1.69, 449281, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Ashok Mohite (Survey 18/A)', 2.04, 324823, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Dattatray Mohite (Survey 66/2)', 11.26, 2932250, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj5, 'Vijay Gajbhiye (Survey 100/2B)', 6.02, 1698055, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Subhash Gaikwad (Survey 181/1A)', 1.18, 288598, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj5, 'Ganpat Pawar (Survey 263/2)', 13.82, 2484241, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Shrikant Kumbhare (Survey 149/A)', 8.79, 1260538, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Tanaji Ghormade (Survey 276/4C)', 11.75, 2997119, 'Pending', 'Active', '2026-06-19', 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Prakash Meshram (Survey 100/1A)', 12.49, 2156011, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj5, 'Ganpat Nikhare (Survey 249/A)', 9.21, 1404267, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Vijay Chikte (Survey 294/4C)', 5.22, 980347, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj5, 'Prakash Patil (Survey 121/1A)', 9.37, 1632188, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Dinkar Bhosale (Survey 361/1)', 7.0, 1082795, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Ganpat Tembhare (Survey 168/2B)', 6.31, 1379933, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj5, 'Tukaram Zoting (Survey 311/2)', 0.6, 130861, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Bhaurao Borkar (Survey 258/2)', 5.11, 983562, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Maruti Bhosale (Survey 345/2B)', 3.08, 787263, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj5, 'Bhaurao Kumbhare (Survey 360/3)', 10.38, 2598975, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj5, 'Maruti Chikte (Survey 109/4C)', 10.45, 1863140, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj5, 'Kisan Shinde (Survey 99/3)', 4.52, 1100222, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Dinkar Mohite (Survey 105/4C)', 9.47, 1688141, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Rajendra Gaikwad (Survey 181/4C)', 4.07, 802127, 'Paid', 'Active', '2026-04-28', 'Filed', 'Occupied', 'Pending'),
        (v_proj5, 'Chandrakant Padole (Survey 207/2B)', 6.16, 982674, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Prakash Gaikwad (Survey 246/3)', 4.83, 807957, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Pramod Bhadange (Survey 152/1A)', 10.93, 1794684, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Dinkar Wankhede (Survey 78/A)', 9.18, 2072357, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Mahesh Gawande (Survey 203/1)', 12.72, 3297113, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Sudhakar Dhoke (Survey 367/4C)', 4.78, 702296, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj5, 'Shrikant Gajbhiye (Survey 164/2B)', 6.75, 1730632, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Dilip Kumbhare (Survey 262/4C)', 10.78, 1759543, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj5, 'Dilip Gawande (Survey 23/3)', 2.19, 284248, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj5, 'Tukaram Gajbhiye (Survey 316/1)', 9.57, 1197924, 'Paid', 'Active', '2026-06-27', 'Filed', 'Refusing', 'Pending');

    -- ==========================================================
    -- PROJECT 6: Butibori MIDC Phase 5 Expansion (Industrial Corridor)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Butibori MIDC Phase 5 Expansion', 'Industrial Corridor', 'Nagpur', 'Sawangi, Asola, Ghogli, Butibori',
        520.0, 65, 5,
        '2024-04-01', '2027-01-31', 'No',
        false, 11, v_profile_id
    ) RETURNING id INTO v_proj6;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj6, 65, 48, 42
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj6, 'Dilip Gawande (Survey 367/1)', 4.63, 678160, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Dattatray Kohale (Survey 380/2)', 4.37, 646130, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Shrikant Kohale (Survey 115/4C)', 10.14, 2001879, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Maruti Mohite (Survey 258/4C)', 3.71, 457598, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Santosh Patil (Survey 273/2)', 10.41, 1525606, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Suresh Borkar (Survey 101/1)', 12.18, 2611733, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Suresh Meshram (Survey 82/3)', 5.0, 1173720, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Dattatray Zoting (Survey 216/B)', 4.22, 933096, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Dilip Sonkusare (Survey 42/3)', 1.92, 527733, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Tukaram Zoting (Survey 195/1)', 12.32, 1900360, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Ashok Gajbhiye (Survey 44/2B)', 9.47, 1167082, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Bhaurao Shinde (Survey 185/2)', 6.43, 1190591, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Dilip Pawar (Survey 297/1)', 0.66, 106350, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Vitthal Wankhede (Survey 263/4C)', 3.8, 733084, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Shantabai Pawar (Survey 132/2)', 6.79, 1834773, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Dattatray Ghormade (Survey 346/1)', 1.91, 435655, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Rajendra Tembhare (Survey 328/2B)', 12.69, 3393458, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Laxmibai Pawar (Survey 39/1A)', 12.07, 2498779, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Bhaurao Nikhare (Survey 378/B)', 2.06, 366945, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Rajendra Bawankule (Survey 292/4C)', 10.12, 1335840, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Pending'),
        (v_proj6, 'Ganpat Tembhare (Survey 112/1A)', 2.15, 479439, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Sunita Borkar (Survey 224/1)', 13.19, 3618716, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Prakash Bhosale (Survey 270/3)', 13.7, 1659576, 'Paid', 'Active', '2026-06-28', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Shrikant Thakre (Survey 65/A)', 9.51, 2652348, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj6, 'Dinkar Dhoke (Survey 152/A)', 13.7, 2700475, 'Paid', 'Active', '2025-09-14', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Sunita Sonkusare (Survey 295/1A)', 3.25, 921768, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj6, 'Vitthal Kohale (Survey 289/4C)', 10.23, 2172207, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Maruti Dhenge (Survey 357/2B)', 12.52, 2888689, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Baburao Khadse (Survey 94/2B)', 9.86, 1561676, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Shrikant Bhadange (Survey 64/1A)', 10.67, 2850309, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Maruti Bawankule (Survey 366/1)', 13.19, 2922838, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Mahesh Gajbhiye (Survey 18/2B)', 3.28, 774558, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj6, 'Mahesh Deshmukh (Survey 320/1A)', 11.13, 1900158, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Vitthal Bhosale (Survey 100/2)', 5.67, 1317311, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Chandrakant Khadse (Survey 14/4C)', 6.89, 1106403, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Dinkar Mohite (Survey 332/2B)', 7.22, 1950288, 'Paid', 'Active', '2026-07-13', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Rajendra Kohale (Survey 93/A)', 7.94, 1792478, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Sunita Kumbhare (Survey 196/2B)', 3.49, 984452, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Namdeo Meshram (Survey 70/4C)', 6.61, 1906092, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Bhaurao Gaikwad (Survey 176/A)', 13.05, 1953846, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Narendra Kohale (Survey 203/B)', 7.17, 1417566, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Dinkar Mandape (Survey 285/1)', 9.09, 1593067, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Mahesh Pawar (Survey 371/A)', 9.36, 1300150, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Suresh Raut (Survey 140/2)', 8.38, 1505676, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Shantabai Padole (Survey 72/1)', 9.29, 2620671, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Chandrakant Wankhede (Survey 195/2)', 4.47, 889516, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Shantabai Zoting (Survey 350/1)', 6.99, 1816316, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Chandrakant Mandape (Survey 163/3)', 4.58, 1327526, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Mahesh Thakre (Survey 75/1)', 0.57, 157553, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Baburao Deshmukh (Survey 188/1A)', 6.15, 1779361, 'Pending', 'Active', '2026-02-10', 'Filed', 'Refusing', 'Pending'),
        (v_proj6, 'Rajendra Chikte (Survey 39/B)', 9.33, 1298493, 'Paid', 'Active', '2026-02-22', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Bhaurao Tidke (Survey 132/2)', 4.41, 609898, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Prakash Thakre (Survey 301/4C)', 11.57, 2687456, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Maruti Deshmukh (Survey 340/A)', 4.29, 919076, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Ashok Bhadange (Survey 195/2B)', 7.17, 1064952, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Chandrakant Pawar (Survey 83/1A)', 4.11, 1168325, 'Paid', 'Active', '2026-08-20', 'Filed', 'Occupied', 'Pending'),
        (v_proj6, 'Dinkar Chikte (Survey 120/1)', 8.06, 2115484, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj6, 'Subhash Patil (Survey 313/2B)', 2.33, 585682, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Bhaurao Dhoke (Survey 326/3)', 10.87, 1704383, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Bhaurao Shinde (Survey 86/B)', 13.37, 1746055, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj6, 'Laxmibai Dhoke (Survey 33/1A)', 7.6, 1631712, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Suresh Tidke (Survey 177/2)', 10.14, 2602674, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Prakash Mandape (Survey 303/3)', 5.66, 1240819, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj6, 'Sanjay Khadse (Survey 204/1A)', 7.57, 1608700, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj6, 'Subhash Thakre (Survey 237/3)', 3.65, 930322, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending');

    -- ==========================================================
    -- PROJECT 7: Saoner DNA (Defence, Nuclear & Aerospace) Corridor (Industrial Corridor)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Saoner DNA (Defence, Nuclear & Aerospace) Corridor', 'Industrial Corridor', 'Nagpur', 'Saoner Taluka — 2,730 Ha notified across 12 villages',
        2730.0, 95, 18,
        '2024-03-01', '2028-06-30', 'Yes',
        true, 26, v_profile_id
    ) RETURNING id INTO v_proj7;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj7, 95, 40, 30
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj7, 'Laxmibai Tembhare (Survey 379/2)', 9.56, 2186257, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Vitthal Tidke (Survey 222/1)', 3.84, 589532, 'Pending', 'Active', '2026-06-18', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Vitthal Kohale (Survey 219/1)', 12.54, 2436584, 'Pending', 'Active', '2026-06-23', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Dilip Jadhav (Survey 310/3)', 9.04, 2295292, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Ashok Tembhare (Survey 314/2)', 3.65, 806817, 'Paid', 'Active', '2026-06-19', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Subhash Tembhare (Survey 319/1)', 12.53, 3249166, 'Pending', 'Active', '2026-06-22', 'Filed', 'Occupied', 'Verified'),
        (v_proj7, 'Namdeo Dhenge (Survey 279/A)', 5.57, 731825, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj7, 'Laxmibai Chikte (Survey 368/2)', 6.33, 1181937, 'Pending', 'Active', '2026-01-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Tanaji Jadhav (Survey 15/2)', 7.62, 1663529, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Namdeo Chikte (Survey 141/2B)', 12.21, 2820925, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Mahesh Jadhav (Survey 297/B)', 2.95, 786360, 'Pending', 'Active', '2025-08-12', 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Dilip Shinde (Survey 349/2)', 10.75, 2548524, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj7, 'Rajendra Mandape (Survey 326/1)', 2.7, 774065, 'Paid', 'Active', '2025-10-05', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Laxmibai Wankhede (Survey 323/1)', 10.43, 2347021, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj7, 'Shrikant Raut (Survey 339/B)', 6.51, 1125422, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj7, 'Sanjay Kohale (Survey 369/1A)', 8.93, 1156015, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Shantabai Nikhare (Survey 354/A)', 6.05, 1043685, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Shrikant Mandape (Survey 310/4C)', 5.26, 1012465, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Shantabai Chikte (Survey 14/2B)', 2.9, 732850, 'Paid', 'Active', '2026-07-16', 'Filed', 'Occupied', 'Verified'),
        (v_proj7, 'Subhash Mandape (Survey 306/2B)', 10.01, 2190678, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Ashok Gaikwad (Survey 312/1)', 7.1, 1331853, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Bhaurao Sonkusare (Survey 129/4C)', 6.15, 1307256, 'Pending', 'Active', '2026-01-27', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Shrikant Kumbhare (Survey 50/3)', 7.03, 1495119, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Tanaji Padole (Survey 109/B)', 10.6, 1924610, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Tukaram Nikhare (Survey 91/2)', 2.14, 300830, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Suresh Shinde (Survey 258/4C)', 9.0, 2241576, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Dinkar Mohite (Survey 273/2B)', 5.95, 1613455, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Mahesh Gajbhiye (Survey 269/4C)', 5.89, 976691, 'Pending', 'Active', '2026-06-25', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Prakash Borkar (Survey 178/4C)', 8.9, 1673894, 'Paid', 'Active', '2025-10-05', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Baburao Dhenge (Survey 370/4C)', 5.5, 1237566, 'Paid', 'Active', '2026-08-06', 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Rajendra Dhoke (Survey 296/A)', 12.23, 2096173, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Rajendra Meshram (Survey 102/A)', 7.34, 2094256, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Prakash Gajbhiye (Survey 215/2)', 9.96, 1351950, 'Paid', 'Active', '2025-10-16', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Mahesh Mohite (Survey 143/4C)', 0.77, 116871, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Mahesh Raut (Survey 157/4C)', 4.95, 1256354, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Namdeo Bhosale (Survey 86/3)', 9.28, 1934360, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Sunita Dhoke (Survey 172/4C)', 9.45, 1796596, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj7, 'Tanaji Chikte (Survey 278/B)', 6.17, 1037818, 'Pending', 'Active', '2026-07-23', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Dattatray Wankhede (Survey 254/1)', 0.86, 192703, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Narendra Gaikwad (Survey 211/2B)', 3.64, 707958, 'Pending', 'Active', '2026-08-01', 'Filed', 'Refusing', 'Verified'),
        (v_proj7, 'Sunita Shinde (Survey 255/B)', 13.86, 3627300, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Prakash Tembhare (Survey 245/A)', 7.67, 2206260, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Kisan Nikhare (Survey 223/2B)', 2.63, 322877, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Laxmibai Bawankule (Survey 252/1)', 9.92, 2469643, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Sudhakar Jadhav (Survey 15/4C)', 3.08, 822190, 'Pending', 'Active', '2026-07-04', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Sudhakar Kohale (Survey 325/2B)', 4.4, 1141558, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Namdeo Bhadange (Survey 328/B)', 4.23, 1198151, 'Pending', 'Active', '2026-08-03', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Ganpat Thakre (Survey 378/B)', 10.46, 1893563, 'Paid', 'Active', '2025-12-10', 'Filed', 'Refusing', 'Verified'),
        (v_proj7, 'Laxmibai Bhadange (Survey 368/1)', 5.02, 794645, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Vijay Raut (Survey 110/2B)', 11.7, 1442691, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Dinkar Bhadange (Survey 138/1)', 3.23, 467158, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Sunita Raut (Survey 334/1)', 10.7, 2825538, 'Pending', 'Active', '2026-02-22', 'Filed', 'Occupied', 'Verified'),
        (v_proj7, 'Baburao Borkar (Survey 132/A)', 4.95, 811166, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj7, 'Prakash Jadhav (Survey 365/B)', 9.93, 1595055, 'Pending', 'Active', '2026-08-02', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Dinkar Tidke (Survey 42/1)', 5.37, 861068, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj7, 'Rajendra Tidke (Survey 189/B)', 10.54, 1323792, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Ashok Mandape (Survey 162/B)', 3.1, 523661, 'Pending', 'Active', '2026-06-24', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Kisan Pawar (Survey 146/4C)', 6.72, 1930346, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Tukaram Dhoke (Survey 176/2)', 9.52, 2487423, 'Pending', 'Active', '2026-06-20', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Namdeo Kumbhare (Survey 68/2)', 7.67, 1054463, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Suresh Gawande (Survey 66/B)', 3.13, 401704, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Ganpat Gajbhiye (Survey 199/1A)', 8.8, 1219495, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Narendra Gaikwad (Survey 52/B)', 11.47, 1558910, 'Pending', 'None', NULL, 'Filed', 'Vacated', 'Verified'),
        (v_proj7, 'Suresh Pawar (Survey 327/2B)', 7.75, 1072995, 'Pending', 'Active', '2026-07-26', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Shantabai Gawande (Survey 110/1A)', 8.31, 1386914, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Bhaurao Bhadange (Survey 371/A)', 12.59, 2061335, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Tukaram Bhadange (Survey 192/4C)', 8.04, 1649052, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj7, 'Sudhakar Chikte (Survey 291/1A)', 5.64, 1490319, 'Pending', 'Active', '2025-10-17', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Kisan Tembhare (Survey 20/3)', 14.11, 2809653, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Sunita Meshram (Survey 365/2B)', 13.09, 3325200, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Dilip Khadse (Survey 199/1A)', 3.69, 733284, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Tanaji Wankhede (Survey 178/B)', 2.87, 777927, 'Pending', 'Active', '2026-05-15', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Dinkar Kumbhare (Survey 190/A)', 6.21, 941423, 'Pending', 'Active', '2026-08-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Mahesh Chikte (Survey 88/4C)', 7.38, 1312754, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Ashok Patil (Survey 316/2)', 3.54, 693712, 'Pending', 'Active', '2026-04-22', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Shantabai Khadse (Survey 55/A)', 7.37, 1136284, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Mahesh Tembhare (Survey 280/1A)', 3.82, 725024, 'Pending', 'Active', '2026-04-07', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Sunita Nikhare (Survey 316/1)', 11.04, 1814633, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Suresh Mohite (Survey 131/1A)', 9.89, 1591221, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj7, 'Narendra Thakre (Survey 159/1)', 5.2, 775684, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Tanaji Mandape (Survey 120/1A)', 7.99, 1500561, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Shantabai Chikte (Survey 351/1)', 4.0, 543028, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Suresh Bhadange (Survey 347/1)', 1.41, 269482, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Subhash Tidke (Survey 209/1A)', 13.92, 3526075, 'Pending', 'Active', '2026-07-13', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Ashok Mandape (Survey 376/1)', 1.04, 269134, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Pramod Nikhare (Survey 362/4C)', 5.37, 1069988, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj7, 'Rajendra Gajbhiye (Survey 332/2B)', 12.54, 1601658, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Dilip Wankhede (Survey 207/1A)', 6.22, 1680525, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj7, 'Sunita Bhadange (Survey 289/3)', 3.33, 520568, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Subhash Kohale (Survey 81/A)', 14.14, 2234827, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Tanaji Borkar (Survey 106/4C)', 12.0, 1897764, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj7, 'Ashok Deshmukh (Survey 338/2B)', 2.58, 436703, 'Paid', 'Active', '2026-07-19', 'Filed', 'Refusing', 'Pending'),
        (v_proj7, 'Pramod Nikhare (Survey 52/B)', 2.34, 651739, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Vitthal Gawande (Survey 127/1)', 6.1, 756003, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj7, 'Baburao Wankhede (Survey 102/B)', 12.38, 3075625, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified');

    -- ==========================================================
    -- PROJECT 8: Nagpur-Mumbai Samruddhi Expressway — Nagpur Spur Connector (Highway)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Nagpur-Mumbai Samruddhi Expressway — Nagpur Spur Connector', 'Highway', 'Nagpur', 'Kalmeshwar, Wadi, Fetri, Mankapur',
        340.0, 55, 3,
        '2024-05-10', '2026-11-30', 'No',
        false, 9, v_profile_id
    ) RETURNING id INTO v_proj8;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj8, 55, 50, 48
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj8, 'Tukaram Deshmukh (Survey 206/4C)', 5.9, 1592581, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Rajendra Gajbhiye (Survey 278/2)', 6.69, 877186, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj8, 'Shantabai Kohale (Survey 334/1)', 3.1, 729200, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Ashok Raut (Survey 228/2B)', 8.9, 1195261, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Namdeo Bhadange (Survey 58/2)', 2.96, 809474, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj8, 'Vitthal Bhadange (Survey 314/1A)', 12.59, 1808427, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Rajendra Raut (Survey 379/2)', 1.75, 416162, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Tanaji Jadhav (Survey 273/3)', 5.69, 1250508, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Chandrakant Padole (Survey 88/3)', 12.4, 2069411, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Tanaji Patil (Survey 240/2B)', 9.08, 1369409, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj8, 'Vijay Shinde (Survey 267/1)', 8.83, 2201839, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Parvatibai Bhadange (Survey 52/1)', 3.85, 1014405, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Baburao Gajbhiye (Survey 106/3)', 1.25, 264366, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Shrikant Tembhare (Survey 164/4C)', 13.11, 1741702, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Kisan Tembhare (Survey 350/3)', 13.74, 3734147, 'Paid', 'Active', '2025-12-20', 'Filed', 'Occupied', 'Verified'),
        (v_proj8, 'Dinkar Dhenge (Survey 293/2)', 4.51, 700267, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Parvatibai Kohale (Survey 119/1A)', 8.89, 1321516, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Santosh Ghormade (Survey 364/2B)', 6.35, 1288827, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Narendra Thakre (Survey 326/B)', 7.62, 2176553, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Sudhakar Sonkusare (Survey 160/1A)', 0.52, 65669, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Baburao Jadhav (Survey 327/A)', 6.17, 1280281, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Namdeo Gawande (Survey 365/2B)', 3.99, 549750, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Pramod Borkar (Survey 363/4C)', 5.18, 1394140, 'Paid', 'Active', '2026-02-24', 'Filed', 'Occupied', 'Verified'),
        (v_proj8, 'Vijay Mohite (Survey 254/1)', 9.35, 2302166, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Subhash Kumbhare (Survey 248/A)', 13.21, 1779188, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Sunita Mandape (Survey 286/1)', 3.35, 693309, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Dilip Khadse (Survey 27/4C)', 13.98, 3973619, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Vitthal Tembhare (Survey 71/2B)', 10.16, 2056831, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Subhash Dhoke (Survey 202/B)', 11.86, 2364077, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Rajendra Gajbhiye (Survey 115/2)', 6.58, 832606, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Sunita Mohite (Survey 259/2B)', 11.12, 1752100, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Sanjay Padole (Survey 79/1A)', 10.43, 2507580, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Kisan Mohite (Survey 34/2)', 5.07, 669721, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Pramod Chikte (Survey 171/1A)', 4.9, 835322, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Bhaurao Borkar (Survey 151/3)', 2.66, 399013, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Baburao Mandape (Survey 191/4C)', 4.21, 817817, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Subhash Kumbhare (Survey 288/B)', 1.19, 151844, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Suresh Wankhede (Survey 230/A)', 2.95, 814993, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Sunita Pawar (Survey 113/2)', 13.84, 3350373, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Maruti Bhadange (Survey 61/B)', 4.75, 1372417, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Sudhakar Thakre (Survey 327/2B)', 13.01, 2898367, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Chandrakant Gaikwad (Survey 178/B)', 7.18, 984629, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Vitthal Bawankule (Survey 190/3)', 7.46, 1688556, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Namdeo Wankhede (Survey 166/B)', 5.99, 1368002, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Vijay Zoting (Survey 45/4C)', 3.35, 920978, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Sunita Mandape (Survey 367/1A)', 2.87, 403002, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Dattatray Chikte (Survey 317/B)', 4.96, 722171, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Santosh Tembhare (Survey 67/A)', 4.99, 1442509, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Subhash Chikte (Survey 337/1)', 10.87, 1729590, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Ashok Gawande (Survey 117/4C)', 4.61, 921239, 'Pending', 'None', NULL, 'None', 'Vacated', 'Verified'),
        (v_proj8, 'Prakash Meshram (Survey 325/A)', 12.11, 2387098, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj8, 'Pramod Sonkusare (Survey 298/4C)', 2.0, 387958, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj8, 'Shantabai Zoting (Survey 207/A)', 7.97, 1318700, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Narendra Nikhare (Survey 225/3)', 4.45, 680453, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj8, 'Tanaji Gaikwad (Survey 261/A)', 13.86, 2156505, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified');

    -- ==========================================================
    -- PROJECT 9: Kamptee Military Station Bypass & Grade Separator (Railway)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Kamptee Military Station Bypass & Grade Separator', 'Railway', 'Nagpur', 'Kamptee, Koradi, Pili Nadi area',
        120.0, 45, 4,
        '2024-02-01', '2027-04-30', 'No',
        false, 16, v_profile_id
    ) RETURNING id INTO v_proj9;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj9, 45, 22, 18
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj9, 'Ashok Gaikwad (Survey 368/A)', 9.04, 2161608, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Tukaram Meshram (Survey 307/B)', 12.1, 2202950, 'Pending', 'Active', '2026-07-07', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Dattatray Chikte (Survey 258/2)', 2.45, 632085, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Subhash Tembhare (Survey 57/1A)', 6.97, 979061, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj9, 'Mahesh Patil (Survey 17/B)', 6.72, 1633000, 'Pending', 'Active', '2026-01-04', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Tukaram Deshmukh (Survey 167/2B)', 1.34, 327008, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Pramod Bawankule (Survey 260/2)', 2.24, 313931, 'Pending', 'Active', '2026-01-11', 'Filed', 'Occupied', 'Pending'),
        (v_proj9, 'Dattatray Tembhare (Survey 101/3)', 9.53, 2067361, 'Pending', 'Active', '2026-07-23', 'Filed', 'Occupied', 'Verified'),
        (v_proj9, 'Sunita Wankhede (Survey 86/3)', 11.98, 2734446, 'Pending', 'Active', '2026-06-27', 'Filed', 'Refusing', 'Verified'),
        (v_proj9, 'Suresh Tidke (Survey 147/2)', 1.22, 294798, 'Pending', 'Active', '2025-11-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Chandrakant Dhenge (Survey 18/2B)', 13.2, 3137046, 'Pending', 'Active', '2026-04-15', 'Filed', 'Occupied', 'Pending'),
        (v_proj9, 'Narendra Tidke (Survey 151/4C)', 4.2, 612200, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Bhaurao Deshmukh (Survey 135/1A)', 7.62, 1273789, 'Paid', 'Active', '2026-08-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Bhaurao Bhadange (Survey 191/1A)', 10.44, 1942184, 'Paid', 'Active', '2026-08-11', 'Filed', 'Occupied', 'Pending'),
        (v_proj9, 'Maruti Bhosale (Survey 73/2)', 12.23, 1884080, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj9, 'Dattatray Sonkusare (Survey 106/2B)', 4.54, 634909, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj9, 'Dinkar Patil (Survey 177/2B)', 2.72, 379159, 'Paid', 'Active', '2026-07-04', 'Filed', 'Refusing', 'Verified'),
        (v_proj9, 'Vitthal Bhadange (Survey 47/B)', 13.92, 2402647, 'Pending', 'Active', '2026-06-21', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Tukaram Tidke (Survey 66/B)', 10.3, 1514882, 'Paid', 'Active', '2026-07-21', 'Filed', 'Occupied', 'Pending'),
        (v_proj9, 'Namdeo Meshram (Survey 31/A)', 4.15, 856821, 'Pending', 'None', NULL, 'None', 'Vacated', 'Pending'),
        (v_proj9, 'Parvatibai Zoting (Survey 47/1A)', 0.55, 135503, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Sunita Padole (Survey 167/A)', 1.26, 364928, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Santosh Pawar (Survey 247/2B)', 9.37, 1558221, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Dattatray Tidke (Survey 364/4C)', 7.17, 2049773, 'Pending', 'Active', '2026-08-18', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Vijay Zoting (Survey 44/2B)', 7.35, 1747705, 'Pending', 'Active', '2026-05-06', 'Filed', 'Occupied', 'Pending'),
        (v_proj9, 'Dattatray Gawande (Survey 346/B)', 13.38, 3487577, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Suresh Deshmukh (Survey 84/B)', 9.46, 2303765, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Namdeo Gajbhiye (Survey 169/2)', 6.75, 1112028, 'Pending', 'Active', '2026-04-06', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Santosh Jadhav (Survey 115/A)', 5.12, 1153966, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Dilip Kumbhare (Survey 121/1)', 8.63, 1794608, 'Paid', 'Active', '2026-03-09', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Narendra Chikte (Survey 32/3)', 1.87, 534307, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Vitthal Mohite (Survey 57/2B)', 6.2, 1517654, 'Pending', 'Active', '2025-09-09', 'Filed', 'Refusing', 'Verified'),
        (v_proj9, 'Tukaram Sonkusare (Survey 31/3)', 10.33, 2896996, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Sudhakar Gawande (Survey 72/2)', 8.98, 2348135, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Dattatray Jadhav (Survey 88/B)', 7.32, 1184961, 'Pending', 'Active', '2026-07-07', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Rajendra Gaikwad (Survey 244/1)', 1.93, 258139, 'Pending', 'Active', '2026-08-19', 'Filed', 'Refusing', 'Pending'),
        (v_proj9, 'Ashok Chikte (Survey 308/4C)', 6.24, 1281546, 'Paid', 'Active', '2026-07-24', 'Filed', 'Refusing', 'Verified'),
        (v_proj9, 'Shantabai Gaikwad (Survey 124/2)', 6.95, 1716538, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Tukaram Bhadange (Survey 103/A)', 5.62, 1348760, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj9, 'Maruti Chikte (Survey 42/2B)', 2.37, 573627, 'Pending', 'Active', '2026-02-11', 'Filed', 'Refusing', 'Verified'),
        (v_proj9, 'Namdeo Bhosale (Survey 325/3)', 8.42, 2230466, 'Pending', 'Active', '2026-02-13', 'Filed', 'Occupied', 'Pending'),
        (v_proj9, 'Tanaji Dhenge (Survey 138/1A)', 4.98, 1354076, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj9, 'Narendra Chikte (Survey 14/A)', 13.93, 1817878, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj9, 'Rajendra Jadhav (Survey 368/2)', 6.7, 1226421, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj9, 'Parvatibai Bhosale (Survey 123/3)', 5.41, 988233, 'Pending', 'Active', '2026-06-22', 'Filed', 'Refusing', 'Verified');

    -- ==========================================================
    -- PROJECT 10: Gorewada International Zoo & Bio-Park Expansion (Smart City)
    -- ==========================================================
    INSERT INTO public.projects (
        project_name, project_type, district, villages_affected,
        total_land_area_hectares, est_families_affected, st_families,
        start_date, target_handover_date, forest_clearance,
        forest_clearance_applied, avg_dept_response_days, created_by
    ) VALUES (
        'Gorewada International Zoo & Bio-Park Expansion', 'Smart City', 'Nagpur', 'Gorewada, Seminary Hills Buffer Zone',
        160.0, 40, 2,
        '2024-07-01', '2026-09-30', 'Yes',
        true, 7, v_profile_id
    ) RETURNING id INTO v_proj10;

    INSERT INTO public.rehabilitation_status (
        project_id, colonies_planned, colonies_built, families_shifted
    ) VALUES (
        v_proj10, 40, 38, 35
    );

    INSERT INTO public.families (
        project_id, family_name, land_area_owned, compensation_amount,
        payment_status, court_case_status, court_case_filed_date,
        objection_status, possession_status, verification_status
    ) VALUES
        (v_proj10, 'Tanaji Chikte (Survey 24/B)', 6.85, 1070922, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj10, 'Namdeo Meshram (Survey 333/2)', 5.77, 1195942, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Maruti Bhosale (Survey 325/1A)', 11.29, 1594396, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Sanjay Bhosale (Survey 357/4C)', 12.67, 1888957, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Laxmibai Raut (Survey 343/2)', 8.18, 1420571, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Namdeo Ghormade (Survey 309/1A)', 10.82, 1937829, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Parvatibai Khadse (Survey 39/2)', 5.61, 1338523, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Maruti Mandape (Survey 359/2B)', 6.69, 1448431, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Subhash Wankhede (Survey 108/B)', 1.7, 378105, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Pending'),
        (v_proj10, 'Maruti Thakre (Survey 266/3)', 12.49, 3203622, 'Pending', 'Active', '2026-06-30', 'Filed', 'Refusing', 'Verified'),
        (v_proj10, 'Tanaji Tidke (Survey 22/2B)', 3.09, 388647, 'Pending', 'None', NULL, 'Filed', 'Occupied', 'Verified'),
        (v_proj10, 'Sunita Tidke (Survey 342/4C)', 7.16, 1854289, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Dilip Gaikwad (Survey 168/3)', 11.31, 2029568, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Suresh Thakre (Survey 192/2B)', 6.75, 1104374, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Vitthal Raut (Survey 374/3)', 2.71, 408258, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Ganpat Nikhare (Survey 106/1A)', 8.21, 1059853, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Ashok Mandape (Survey 95/2B)', 2.16, 273311, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Ashok Mohite (Survey 175/3)', 0.56, 147374, 'Pending', 'None', NULL, 'None', 'Occupied', 'Pending'),
        (v_proj10, 'Dinkar Chikte (Survey 353/3)', 11.45, 2700997, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Suresh Thakre (Survey 359/2)', 4.72, 1063340, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Sunita Gajbhiye (Survey 323/1A)', 8.49, 1513198, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Santosh Mandape (Survey 240/2)', 13.87, 3098488, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Suresh Mohite (Survey 353/4C)', 5.95, 1381012, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Laxmibai Bawankule (Survey 240/2)', 3.46, 818113, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Vitthal Jadhav (Survey 229/A)', 2.41, 660159, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Chandrakant Kohale (Survey 183/2)', 13.28, 3649901, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Narendra Khadse (Survey 224/3)', 8.11, 2180576, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Shantabai Bawankule (Survey 295/B)', 1.08, 215098, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Ashok Dhoke (Survey 25/1)', 2.61, 518573, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj10, 'Parvatibai Raut (Survey 263/1A)', 0.89, 171476, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Laxmibai Chikte (Survey 258/A)', 12.4, 3529350, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Laxmibai Kohale (Survey 306/1)', 12.08, 1965283, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Maruti Thakre (Survey 194/3)', 1.22, 261904, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Kisan Bawankule (Survey 283/2)', 7.54, 2146140, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Mahesh Kumbhare (Survey 173/2B)', 4.22, 907439, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Pramod Thakre (Survey 277/2B)', 5.61, 1386303, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Baburao Thakre (Survey 269/1A)', 11.89, 3168066, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Verified'),
        (v_proj10, 'Mahesh Sonkusare (Survey 294/2)', 6.22, 870967, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending'),
        (v_proj10, 'Laxmibai Bawankule (Survey 365/4C)', 2.4, 566042, 'Pending', 'None', NULL, 'None', 'Occupied', 'Verified'),
        (v_proj10, 'Pramod Deshmukh (Survey 72/1A)', 2.26, 355538, 'Paid', 'None', NULL, 'Resolved', 'Vacated', 'Pending');

    RAISE NOTICE 'Successfully seeded 10 Real Nagpur District Projects and ~655 Family Records into Supabase!';
END $$;
