CREATE EXTENSION IF NOT EXISTS postgis;

--CREATE DATABASE sos OWNER "www-data";

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.6
-- Dumped by pg_dump version 9.4.6
-- Started on 2017-11-20 09:27:12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 13 (class 2615 OID 215872)
-- Name: mobilite_transp; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA mobilite_transp AUTHORIZATION "www-data";


SET search_path = mobilite_transp, pg_catalog;

SET default_with_oids = false;

--
-- TOC entry 216 (class 1259 OID 215921)
-- Name: comptage_automatique; Type: TABLE; Schema: mobilite_transp; Owner: -
--

CREATE TABLE comptage_automatique (
    enquete_id integer NOT NULL,
    station_id integer NOT NULL,
    date_tmst timestamp without time zone NOT NULL,
    date_str character varying(10),
    heure_deb integer NOT NULL,
    heure_fin integer,
    heure_intervalle character varying(12),
    nb_total integer,
    nb_vl integer,
    nb_pl integer,
    nb_tc integer,
    nb_2rm integer,
    nb_2r integer,
    nb_pieton integer
);


--
-- TOC entry 212 (class 1259 OID 215891)
-- Name: comptage_dom_station_sens; Type: TABLE; Schema: mobilite_transp; Owner: -
--

CREATE TABLE comptage_dom_station_sens (
    sens_id integer,
    sens_libelle character varying(15)
);


--
-- TOC entry 213 (class 1259 OID 215894)
-- Name: comptage_dom_station_type; Type: TABLE; Schema: mobilite_transp; Owner: -
--

CREATE TABLE comptage_dom_station_type (
    type_id integer,
    type_libelle character varying(25)
);


--
-- TOC entry 219 (class 1259 OID 215968)
-- Name: comptage_enquete; Type: TABLE; Schema: mobilite_transp; Owner: -
--

CREATE TABLE comptage_enquete (
    enquete_id integer NOT NULL,
    comm_insee character varying(5) NOT NULL,
    description text NOT NULL,
    site text,
    date_deb timestamp without time zone,
    date_fin timestamp without time zone,
    moa text,
    moe text,
    d_occupation character varying(3),
    d_rotation character varying(3),
    d_routier character varying(3),
    d_vitesse character varying(3)
);


--
-- TOC entry 218 (class 1259 OID 215966)
-- Name: comptage_enquete_enquete_id_seq; Type: SEQUENCE; Schema: mobilite_transp; Owner: -
--

CREATE SEQUENCE comptage_enquete_enquete_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3422 (class 0 OID 0)
-- Dependencies: 218
-- Name: comptage_enquete_enquete_id_seq; Type: SEQUENCE OWNED BY; Schema: mobilite_transp; Owner: -
--

ALTER SEQUENCE comptage_enquete_enquete_id_seq OWNED BY comptage_enquete.enquete_id;


--
-- TOC entry 215 (class 1259 OID 215899)
-- Name: comptage_station; Type: TABLE; Schema: mobilite_transp; Owner: -
--

CREATE TABLE comptage_station (
    station_id integer NOT NULL,
    comm_insee character varying(5) NOT NULL,
    materiel text,
    type integer,
    sens integer,
    description text,
    date_mes timestamp without time zone,
    date_mhs timestamp without time zone,
    x real,
    y real,
    long real,
    lat real,
    angle_symbole integer,
    shape public.geometry,
    CONSTRAINT enforce_geotype_shape CHECK ((public.geometrytype(shape) = 'POINT'::text)),
    CONSTRAINT enforce_srid_shape CHECK ((public.st_srid(shape) = 3948))
);


--
-- TOC entry 214 (class 1259 OID 215897)
-- Name: comptage_station_station_id_seq; Type: SEQUENCE; Schema: mobilite_transp; Owner: -
--

CREATE SEQUENCE comptage_station_station_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 214
-- Name: comptage_station_station_id_seq; Type: SEQUENCE OWNED BY; Schema: mobilite_transp; Owner: -
--

ALTER SEQUENCE comptage_station_station_id_seq OWNED BY comptage_station.station_id;


--
-- TOC entry 217 (class 1259 OID 215940)
-- Name: v_comptage_station_automatique; Type: VIEW; Schema: mobilite_transp; Owner: -
--

CREATE VIEW v_comptage_station_automatique AS
 SELECT row_number() OVER () AS uid,
    b.station_id,
    b.comm_insee,
    b.type,
    b.sens,
    b.description,
    a.date_tmst,
    a.date_str,
    a.heure_intervalle,
    a.heure_deb,
    a.heure_fin,
    a.nb_total,
    a.nb_vl,
    a.nb_pl,
    a.nb_tc,
    a.nb_2rm,
    a.nb_2r,
    a.nb_pieton,
    (b.shape)::public.geometry(Point,3948) AS shape
   FROM (comptage_automatique a
     LEFT JOIN comptage_station b ON ((a.station_id = b.station_id)));


--
-- TOC entry 3286 (class 2604 OID 215971)
-- Name: enquete_id; Type: DEFAULT; Schema: mobilite_transp; Owner: -
--

ALTER TABLE ONLY comptage_enquete ALTER COLUMN enquete_id SET DEFAULT nextval('comptage_enquete_enquete_id_seq'::regclass);


--
-- TOC entry 3283 (class 2604 OID 215902)
-- Name: station_id; Type: DEFAULT; Schema: mobilite_transp; Owner: -
--

ALTER TABLE ONLY comptage_station ALTER COLUMN station_id SET DEFAULT nextval('comptage_station_station_id_seq'::regclass);


--
-- TOC entry 3415 (class 0 OID 215921)
-- Dependencies: 216
-- Data for Name: comptage_automatique; Type: TABLE DATA; Schema: mobilite_transp; Owner: -
--

INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 80, 77, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 158, 156, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 636, 623, 13, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 582, 571, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 299, 291, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 245, 236, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 220, 208, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 212, 204, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 339, 333, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 245, 238, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 231, 227, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 194, 188, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 232, 222, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 238, 236, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 225, 221, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 100, 97, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 63, 61, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 81, 81, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 156, 155, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 587, 574, 13, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 541, 532, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 319, 310, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 242, 234, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 206, 197, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 256, 249, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 343, 338, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 276, 269, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 278, 271, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 279, 274, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 293, 288, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 231, 227, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 195, 192, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 105, 101, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 59, 57, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 34, 32, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 13, 12, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 32, 31, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 94, 93, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 141, 138, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 635, 623, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 570, 560, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 314, 302, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 240, 228, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 223, 215, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 206, 199, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 278, 272, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 211, 204, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 224, 218, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 218, 211, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 277, 270, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 234, 230, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 196, 193, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 98, 95, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 48, 46, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 36, 35, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 9, 8, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 3, 1, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 74, 73, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 157, 156, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 583, 572, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 591, 581, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 337, 328, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 234, 223, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 243, 235, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 238, 231, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 291, 283, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 294, 287, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 248, 244, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 303, 293, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 328, 320, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 259, 253, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 272, 268, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 170, 166, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 66, 65, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 49, 49, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 24, 24, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 34, 33, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 40, 40, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 10, 9, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 12, 11, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 12, 11, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 37, 37, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 60, 58, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 79, 78, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 208, 206, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 310, 308, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 390, 385, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 343, 341, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 258, 256, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 292, 290, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 412, 411, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 368, 366, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 407, 401, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 329, 328, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 275, 273, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 277, 275, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 119, 117, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 68, 68, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 71, 71, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 61, 61, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 70, 68, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 41, 41, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 16, 15, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 32, 32, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 55, 55, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 95, 95, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 184, 184, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 246, 244, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 235, 232, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 188, 187, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 177, 176, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 214, 213, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 206, 204, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 262, 261, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 255, 252, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 203, 201, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 94, 92, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 42, 42, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 35, 35, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 12, 11, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 36, 36, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 79, 79, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 154, 152, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 627, 617, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 566, 557, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 325, 319, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 258, 250, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 204, 197, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 217, 211, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 350, 342, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 267, 256, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 221, 215, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 255, 242, 13, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 253, 248, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 235, 232, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 198, 196, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 102, 100, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 53, 52, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 32, 32, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 1, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 4, 3, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 96, 94, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 152, 146, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 77, 74, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 73, 72, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 121, 113, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 118, 113, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 107, 106, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 83, 79, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 116, 109, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 135, 129, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 241, 233, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 288, 283, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 163, 163, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 80, 78, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 46, 44, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 40, 40, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 16, 15, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 8, 7, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 80, 78, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 150, 147, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 64, 59, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 89, 77, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 122, 115, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 157, 150, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 94, 89, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 102, 96, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 120, 118, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 146, 141, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 265, 258, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 255, 252, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 172, 171, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 67, 67, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 38, 36, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 28, 27, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 25, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 6, 5, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 8, 7, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 5, 3, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 95, 91, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 136, 133, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 75, 72, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 103, 98, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 113, 106, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 111, 103, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 102, 98, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 117, 109, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 96, 89, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 148, 144, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 238, 229, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 283, 278, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 170, 168, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 87, 87, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 35, 33, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 38, 38, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 3, 2, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 17, 16, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 90, 88, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 140, 137, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 68, 59, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 91, 86, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 109, 104, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 143, 135, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 112, 110, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 118, 110, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 135, 127, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 235, 230, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 257, 254, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 280, 278, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 174, 174, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 105, 104, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 58, 56, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 53, 51, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 47, 46, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 29, 28, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 14, 13, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 76, 75, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 79, 75, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 103, 100, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 163, 161, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 178, 170, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 117, 113, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 116, 116, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 144, 139, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 196, 195, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 226, 219, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 227, 223, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 166, 164, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 71, 70, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 48, 48, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 66, 66, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 43, 43, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 44, 44, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 27, 27, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 35, 32, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 53, 53, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 86, 86, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 148, 147, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 144, 144, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 104, 103, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 74, 73, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 84, 83, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 90, 90, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 134, 132, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 134, 129, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 73, 71, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 37, 37, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 44, 43, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 1, 0, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 6, 5, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 98, 96, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 117, 112, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 103, 95, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 108, 104, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 97, 89, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 129, 126, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 90, 86, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 96, 91, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 105, 95, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 152, 148, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 262, 254, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 276, 270, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 165, 163, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 90, 90, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 49, 48, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 36, 35, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 10, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 1, 0, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 6, 5, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 138, 133, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 308, 307, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 68, 65, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 50, 46, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 49, 38, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 32, 30, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 49, 48, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 39, 38, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 66, 63, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 68, 65, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 54, 52, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 41, 40, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 4, 3, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 142, 138, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 276, 270, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 47, 45, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 44, 44, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 36, 33, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 56, 53, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 55, 54, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 68, 63, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 75, 68, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 68, 58, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 63, 60, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 62, 61, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 34, 34, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 2, 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 16, 15, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 145, 139, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 310, 305, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 60, 55, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 46, 41, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 27, 26, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 36, 36, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 37, 37, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 40, 37, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 45, 44, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 67, 64, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 57, 51, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 69, 64, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 33, 32, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 32, 32, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 1, 0, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 29, 25, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 138, 134, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 282, 280, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 40, 38, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 43, 40, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 52, 47, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 41, 39, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 53, 49, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 37, 36, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 68, 61, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 87, 83, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 75, 72, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 74, 71, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 56, 55, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 32, 31, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 15, 14, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 7, 6, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 1, 0, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 43, 38, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 96, 86, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 121, 114, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 109, 97, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 58, 57, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 43, 41, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 118, 108, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 93, 89, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 77, 66, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 76, 68, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 59, 58, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 52, 52, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 7, 6, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 15, 15, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 26, 25, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 45, 45, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 80, 79, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 54, 54, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 33, 32, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 36, 36, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 33, 31, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 44, 43, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 43, 42, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 30, 29, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 15, 14, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 17, 16, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 144, 140, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 290, 287, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 64, 60, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 53, 50, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 40, 38, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 39, 38, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 54, 54, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 49, 47, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 43, 42, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 70, 68, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 68, 64, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 67, 64, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 33, 32, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 27, 26, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 13, 12, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 11, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 5, 4, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 22, 20, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 55, 52, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 42, 39, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 41, 39, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 58, 52, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 40, 40, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 29, 26, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 44, 40, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 41, 38, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 66, 63, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 154, 153, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 154, 151, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 81, 78, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 38, 37, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 20, 19, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 5, 4, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 49, 45, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 29, 26, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 37, 34, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 65, 64, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 67, 62, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 41, 38, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 67, 58, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 73, 71, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 84, 78, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 141, 137, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 130, 129, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 60, 59, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 38, 36, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 18, 16, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 18, 17, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 52, 51, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 37, 33, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 30, 29, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 55, 50, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 51, 49, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 32, 31, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 46, 44, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 44, 40, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 63, 59, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 147, 146, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 147, 143, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 67, 65, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 38, 38, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 18, 17, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 6, 5, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 23, 21, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 55, 52, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 28, 26, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 37, 35, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 49, 47, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 63, 59, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 44, 43, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 89, 86, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 50, 48, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 101, 99, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 167, 165, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 147, 145, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 81, 79, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 32, 31, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 21, 20, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 2, 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 59, 53, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 78, 74, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 117, 106, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 86, 79, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 51, 51, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 92, 79, 13, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 91, 82, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 105, 97, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 90, 81, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 61, 60, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 58, 56, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 26, 25, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 2, 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 44, 44, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 61, 61, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 41, 41, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 51, 51, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 25, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 35, 35, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 57, 56, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 48, 48, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 19, 17, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 90, 90, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 50, 48, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 35, 33, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 56, 52, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 46, 44, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 35, 33, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 48, 44, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 43, 40, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 64, 61, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 149, 147, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 146, 145, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 63, 62, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 25, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 12, 11, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 12, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 11, 10, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 4, 3, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 8, 7, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 17, 14, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 22, 19, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 77, 73, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 181, 168, 13, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 119, 112, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 168, 161, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 221, 211, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 295, 287, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 221, 215, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 195, 186, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 268, 260, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 368, 358, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 612, 603, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 678, 671, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 452, 448, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 204, 201, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 115, 115, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 94, 94, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 48, 47, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 5, 4, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 8, 6, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 17, 15, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 24, 21, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 88, 83, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 196, 185, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 133, 125, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 155, 148, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 272, 263, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 360, 350, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 205, 198, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 219, 212, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 266, 259, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 353, 343, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 673, 665, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 640, 635, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 452, 448, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 175, 174, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 133, 132, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 91, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 56, 55, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 25, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 13, 12, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 4, 2, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 11, 9, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 22, 18, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 81, 75, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 159, 149, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 131, 120, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 174, 165, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 222, 214, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 292, 285, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 212, 203, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 218, 210, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 288, 280, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 372, 363, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 602, 592, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 672, 665, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 381, 377, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 205, 202, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 131, 128, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 101, 100, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 57, 57, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 27, 26, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 2, 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 14, 12, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 22, 19, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 79, 74, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 187, 175, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 147, 138, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 206, 197, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 250, 241, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 329, 320, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 258, 250, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 308, 302, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 314, 305, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 469, 457, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 640, 629, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 613, 607, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 414, 410, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 251, 250, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 173, 169, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 126, 125, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 83, 83, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 71, 70, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 52, 52, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 9, 8, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 14, 13, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 19, 18, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 21, 20, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 31, 29, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 90, 86, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 133, 127, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 237, 230, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 352, 346, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 403, 396, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 275, 271, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 254, 250, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 318, 312, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 369, 365, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 456, 451, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 470, 467, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 457, 455, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 178, 176, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 103, 102, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 119, 118, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 88, 87, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 109, 108, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 60, 60, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 37, 37, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 38, 37, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 104, 101, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 158, 158, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 206, 204, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 220, 217, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 143, 141, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 133, 133, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 158, 156, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 154, 152, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 275, 275, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 290, 285, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 201, 198, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 100, 98, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 79, 79, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 51, 51, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 3, 2, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 9, 8, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 27, 23, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 79, 74, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 175, 168, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 138, 127, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 183, 176, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 216, 208, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 289, 280, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 217, 209, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 203, 196, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 269, 260, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 366, 359, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 577, 568, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 605, 598, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 438, 435, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 207, 204, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 144, 142, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 88, 88, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 2, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 51, 51, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 2, 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 110, 110, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 212, 211, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 82, 79, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 61, 61, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 80, 79, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 68, 67, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 106, 104, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 76, 74, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 60, 60, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 136, 135, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 138, 136, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 128, 127, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 52, 52, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 21, 20, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 101, 101, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 209, 208, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 77, 72, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 62, 61, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 87, 86, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 128, 127, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 105, 104, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 91, 89, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 82, 82, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 99, 98, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 122, 121, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 152, 152, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 90, 90, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 51, 50, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 20, 19, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 105, 105, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 229, 229, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 76, 73, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 58, 58, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 67, 64, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 64, 62, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 97, 95, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 59, 58, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 78, 77, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 112, 112, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 127, 127, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 134, 134, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 76, 76, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 45, 43, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 18, 16, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 95, 92, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 217, 216, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 73, 71, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 66, 64, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 92, 90, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 79, 77, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 89, 86, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 73, 73, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 90, 90, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 133, 130, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 145, 145, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 141, 141, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 107, 107, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 64, 64, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 15, 15, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 15, 15, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 25, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 64, 64, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 63, 63, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 104, 103, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 118, 118, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 123, 122, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 85, 85, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 98, 96, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 91, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 108, 108, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 80, 79, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 105, 105, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 98, 98, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 49, 49, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 37, 37, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 49, 49, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 93, 93, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 106, 105, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 107, 107, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 61, 61, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 43, 42, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 53, 52, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 45, 45, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 86, 84, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 92, 91, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 66, 66, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 27, 26, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 15, 15, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 102, 101, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 204, 204, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 60, 60, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 62, 59, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 75, 74, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 72, 71, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 86, 85, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 74, 74, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 77, 77, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 110, 106, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 106, 105, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 105, 105, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 97, 97, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 48, 47, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 15, 15, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 3, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 92, 92, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 158, 157, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 67, 66, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 52, 52, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 84, 83, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 106, 106, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 82, 78, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 59, 58, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 73, 71, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 134, 133, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 153, 151, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 181, 181, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 101, 101, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 55, 55, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 3, 2, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 77, 77, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 162, 161, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 66, 66, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 66, 64, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 90, 86, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 144, 144, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 64, 63, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 63, 62, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 81, 81, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 103, 101, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 170, 170, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 196, 196, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 104, 103, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 56, 56, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 15, 14, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 15, 15, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 4, 3, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 4, 3, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 15, 15, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 88, 88, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 140, 139, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 62, 62, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 66, 66, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 70, 67, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 87, 87, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 63, 62, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 68, 66, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 63, 63, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 116, 115, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 160, 159, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 187, 187, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 119, 119, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 51, 51, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 4, 2, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 78, 77, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 132, 131, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 68, 66, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 53, 53, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 88, 87, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 101, 101, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 63, 62, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 72, 71, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 92, 92, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 163, 161, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 171, 168, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 175, 175, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 148, 148, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 71, 71, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 48, 48, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 69, 69, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 103, 103, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 128, 128, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 109, 109, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 83, 83, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 93, 93, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 95, 94, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 99, 98, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 110, 110, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 106, 106, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 91, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 63, 63, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 43, 43, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 54, 54, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 70, 70, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 129, 129, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 91, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 62, 60, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 51, 51, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 46, 45, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 48, 48, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 70, 70, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 77, 77, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 54, 54, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 27, 27, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 4, 3, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 89, 88, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 165, 162, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 62, 61, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 56, 56, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 88, 86, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 80, 79, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 83, 83, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 57, 56, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 88, 87, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 106, 105, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 174, 172, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 177, 177, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 108, 108, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 54, 54, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 4, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 25, 24, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 41, 37, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 35, 31, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 31, 30, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 39, 37, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 40, 40, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 43, 40, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 40, 35, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 31, 28, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 56, 52, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 73, 69, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 95, 89, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 65, 64, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 27, 27, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 31, 29, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 47, 45, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 30, 29, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 44, 43, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 41, 41, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 77, 75, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 27, 25, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 38, 35, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 42, 40, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 60, 55, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 75, 73, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 85, 81, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 62, 61, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 28, 28, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 12, 11, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 6, 4, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 43, 43, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 25, 21, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 46, 43, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 35, 33, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 39, 39, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 36, 32, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 33, 33, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 41, 39, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 48, 48, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 85, 82, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 96, 91, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 62, 60, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 3, 1, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 30, 28, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 38, 37, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 28, 28, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 36, 35, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 43, 39, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 50, 49, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 39, 39, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 36, 35, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 48, 46, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 61, 59, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 93, 91, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 85, 82, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 60, 60, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 33, 33, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 6, 5, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 44, 43, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 49, 47, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 74, 74, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 77, 73, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 39, 39, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 57, 56, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 52, 50, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 52, 51, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 47, 47, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 44, 42, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 45, 43, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 24, 23, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 11, 10, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 20, 19, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 52, 51, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 59, 58, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 44, 44, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 43, 42, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 32, 32, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 31, 28, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 32, 32, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 43, 38, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 51, 47, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 34, 33, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 26, 25, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 26, 22, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 55, 51, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 80, 76, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 88, 85, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 66, 64, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 5, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 56, 50, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 103, 102, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 37, 35, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 34, 32, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 39, 35, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 39, 36, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 26, 25, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 32, 31, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 79, 74, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 64, 62, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 72, 71, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 34, 34, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 28, 27, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 45, 43, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 96, 95, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 57, 57, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 42, 40, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 48, 46, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 42, 35, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 52, 50, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 36, 31, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 56, 52, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 51, 49, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 59, 58, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 87, 86, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 34, 33, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 24, 24, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 12, 11, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 51, 50, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 103, 100, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 44, 38, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 35, 33, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 34, 29, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 38, 36, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 33, 32, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 44, 44, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 56, 56, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 65, 62, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 78, 77, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 44, 44, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 28, 27, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 50, 48, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 83, 83, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 44, 42, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 35, 35, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 33, 31, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 36, 35, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 40, 37, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 49, 46, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 40, 39, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 71, 69, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 75, 73, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 70, 69, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 56, 56, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 29, 28, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 13, 12, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 42, 41, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 66, 66, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 94, 90, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 48, 46, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 36, 35, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 62, 60, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 61, 59, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 45, 44, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 38, 37, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 48, 48, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 42, 40, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 27, 26, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 52, 52, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 48, 48, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 52, 52, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 32, 30, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 34, 34, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 24, 24, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 28, 27, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 46, 45, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 51, 51, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 32, 32, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 22, 21, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 3, 2, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 14, 13, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 41, 39, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 82, 80, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 34, 31, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 38, 38, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 51, 48, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 39, 37, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 38, 37, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 31, 28, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 37, 37, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 59, 58, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 66, 65, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 83, 82, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 36, 36, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 23, 22, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 6, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 12, 11, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 46, 44, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 84, 81, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 64, 60, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 59, 54, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 84, 80, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 91, 85, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 71, 65, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 78, 73, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 103, 98, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 127, 121, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 219, 207, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 200, 194, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 168, 166, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 54, 54, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 36, 36, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 14, 13, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 42, 41, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 93, 90, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 74, 65, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 56, 54, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 102, 90, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 130, 126, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 90, 85, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 77, 73, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 110, 104, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 134, 126, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 221, 210, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 217, 211, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 115, 113, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 64, 64, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 41, 41, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 30, 30, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 16, 15, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 47, 45, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 86, 83, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 61, 56, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 78, 74, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 93, 90, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 82, 78, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 63, 60, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 85, 80, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 104, 99, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 145, 139, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 207, 196, 11, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 192, 189, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 159, 158, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 75, 75, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 32, 32, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 11, 10, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 48, 46, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 88, 84, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 62, 54, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 81, 75, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 100, 92, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 112, 105, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 94, 89, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 92, 88, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 120, 115, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 187, 182, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 228, 216, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 197, 193, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 148, 145, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 88, 88, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 50, 50, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 35, 35, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 16, 15, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 36, 34, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 71, 67, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 89, 86, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 138, 135, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 164, 162, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 93, 90, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 118, 115, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 112, 110, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 124, 121, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 165, 162, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 177, 176, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 158, 158, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 72, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 3, 2, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 42, 40, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 62, 62, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 83, 82, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 134, 132, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 62, 61, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 80, 79, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 67, 65, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 62, 62, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 88, 87, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 87, 85, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 62, 61, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 43, 43, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 10, 10, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 13, 12, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 48, 48, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 86, 84, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 62, 59, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 78, 74, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 108, 103, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 98, 95, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 88, 81, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 64, 61, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 108, 103, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 108, 105, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 213, 204, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 199, 196, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 154, 153, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 69, 69, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 37, 37, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 7, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 61, 59, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 212, 203, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 211, 204, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 128, 124, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 111, 107, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 87, 82, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 58, 55, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 93, 92, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 102, 99, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 88, 85, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 96, 95, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 115, 110, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 115, 112, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 71, 70, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 34, 33, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 21, 21, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 53, 51, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 191, 181, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 221, 213, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 117, 112, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 80, 77, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 123, 118, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 87, 83, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 97, 94, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 114, 111, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 106, 103, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 119, 115, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 109, 106, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 137, 134, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 80, 78, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 52, 51, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 61, 60, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 222, 214, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 222, 216, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 139, 134, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 101, 94, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 85, 79, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 64, 63, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 84, 84, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 84, 78, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 77, 74, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 101, 99, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 128, 123, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 128, 125, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 55, 54, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 40, 39, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 23, 22, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 60, 59, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 192, 183, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 223, 217, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 110, 106, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 106, 100, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 109, 108, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 77, 74, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 94, 94, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 113, 112, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 101, 98, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 124, 120, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 133, 132, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 137, 134, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 117, 116, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 71, 70, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 24, 24, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 16, 15, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 35, 35, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 82, 81, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 113, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 145, 143, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 150, 148, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 89, 88, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 99, 99, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 157, 157, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 130, 130, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 145, 142, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 111, 111, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 109, 108, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 101, 100, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 54, 52, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 16, 16, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 18, 18, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 26, 26, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 50, 50, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 61, 61, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 111, 110, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 60, 60, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 64, 64, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 54, 54, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 75, 75, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 86, 86, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 134, 134, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 143, 143, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 87, 87, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 41, 41, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 15, 15, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 14, 14, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 20, 20, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 55, 54, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 224, 214, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 224, 217, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 115, 110, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 92, 87, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 94, 90, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 84, 79, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 91, 89, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 89, 84, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 93, 92, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 119, 115, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 121, 117, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 131, 129, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 74, 73, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 48, 47, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 25, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 8, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 01:00:00', '11/10/2016', 0, 1, '00H00-01H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 02:00:00', '11/10/2016', 1, 2, '01H00-02H00', 3, 2, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 03:00:00', '11/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 04:00:00', '11/10/2016', 3, 4, '03H00-04H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 05:00:00', '11/10/2016', 4, 5, '04H00-05H00', 8, 7, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 06:00:00', '11/10/2016', 5, 6, '05H00-06H00', 19, 18, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 07:00:00', '11/10/2016', 6, 7, '06H00-07H00', 44, 42, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 08:00:00', '11/10/2016', 7, 8, '07H00-08H00', 187, 178, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 09:00:00', '11/10/2016', 8, 9, '08H00-09H00', 277, 270, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 10:00:00', '11/10/2016', 9, 10, '09H00-10H00', 127, 121, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 11:00:00', '11/10/2016', 10, 11, '10H00-11H00', 114, 110, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 12:00:00', '11/10/2016', 11, 12, '11H00-12H00', 91, 88, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 13:00:00', '11/10/2016', 12, 13, '12H00-13H00', 91, 87, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 14:00:00', '11/10/2016', 13, 14, '13H00-14H00', 120, 116, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 15:00:00', '11/10/2016', 14, 15, '14H00-15H00', 117, 112, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 16:00:00', '11/10/2016', 15, 16, '15H00-16H00', 122, 117, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 17:00:00', '11/10/2016', 16, 17, '16H00-17H00', 111, 106, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 18:00:00', '11/10/2016', 17, 18, '17H00-18H00', 152, 147, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 19:00:00', '11/10/2016', 18, 19, '18H00-19H00', 133, 127, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 20:00:00', '11/10/2016', 19, 20, '19H00-20H00', 109, 107, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 21:00:00', '11/10/2016', 20, 21, '20H00-21H00', 69, 68, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 22:00:00', '11/10/2016', 21, 22, '21H00-22H00', 23, 23, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 23:00:00', '11/10/2016', 22, 23, '22H00-23H00', 13, 12, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-11 00:00:00', '11/10/2016', 23, 0, '23H00-00H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 01:00:00', '12/10/2016', 0, 1, '00H00-01H00', 5, 4, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 02:00:00', '12/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 03:00:00', '12/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 04:00:00', '12/10/2016', 3, 4, '03H00-04H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 05:00:00', '12/10/2016', 4, 5, '04H00-05H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 06:00:00', '12/10/2016', 5, 6, '05H00-06H00', 23, 21, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 07:00:00', '12/10/2016', 6, 7, '06H00-07H00', 45, 45, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 08:00:00', '12/10/2016', 7, 8, '07H00-08H00', 180, 174, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 09:00:00', '12/10/2016', 8, 9, '08H00-09H00', 249, 240, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 10:00:00', '12/10/2016', 9, 10, '09H00-10H00', 112, 105, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 11:00:00', '12/10/2016', 10, 11, '10H00-11H00', 104, 95, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 12:00:00', '12/10/2016', 11, 12, '11H00-12H00', 127, 115, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 13:00:00', '12/10/2016', 12, 13, '12H00-13H00', 110, 107, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 14:00:00', '12/10/2016', 13, 14, '13H00-14H00', 136, 130, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 15:00:00', '12/10/2016', 14, 15, '14H00-15H00', 102, 98, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 16:00:00', '12/10/2016', 15, 16, '15H00-16H00', 126, 121, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 17:00:00', '12/10/2016', 16, 17, '16H00-17H00', 119, 113, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 18:00:00', '12/10/2016', 17, 18, '17H00-18H00', 139, 132, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 19:00:00', '12/10/2016', 18, 19, '18H00-19H00', 167, 166, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 20:00:00', '12/10/2016', 19, 20, '19H00-20H00', 103, 103, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 21:00:00', '12/10/2016', 20, 21, '20H00-21H00', 56, 55, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 22:00:00', '12/10/2016', 21, 22, '21H00-22H00', 29, 29, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 23:00:00', '12/10/2016', 22, 23, '22H00-23H00', 27, 25, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-12 00:00:00', '12/10/2016', 23, 0, '23H00-00H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 01:00:00', '13/10/2016', 0, 1, '00H00-01H00', 5, 4, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 02:00:00', '13/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 03:00:00', '13/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 04:00:00', '13/10/2016', 3, 4, '03H00-04H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 05:00:00', '13/10/2016', 4, 5, '04H00-05H00', 6, 5, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 06:00:00', '13/10/2016', 5, 6, '05H00-06H00', 23, 21, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 07:00:00', '13/10/2016', 6, 7, '06H00-07H00', 35, 33, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 08:00:00', '13/10/2016', 7, 8, '07H00-08H00', 187, 179, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 09:00:00', '13/10/2016', 8, 9, '08H00-09H00', 268, 258, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 10:00:00', '13/10/2016', 9, 10, '09H00-10H00', 118, 112, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 11:00:00', '13/10/2016', 10, 11, '10H00-11H00', 104, 95, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 12:00:00', '13/10/2016', 11, 12, '11H00-12H00', 106, 99, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 13:00:00', '13/10/2016', 12, 13, '12H00-13H00', 109, 97, 12, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 14:00:00', '13/10/2016', 13, 14, '13H00-14H00', 102, 96, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 15:00:00', '13/10/2016', 14, 15, '14H00-15H00', 92, 86, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 16:00:00', '13/10/2016', 15, 16, '15H00-16H00', 106, 100, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 17:00:00', '13/10/2016', 16, 17, '16H00-17H00', 117, 115, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 18:00:00', '13/10/2016', 17, 18, '17H00-18H00', 150, 144, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 19:00:00', '13/10/2016', 18, 19, '18H00-19H00', 156, 155, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 20:00:00', '13/10/2016', 19, 20, '19H00-20H00', 122, 121, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 21:00:00', '13/10/2016', 20, 21, '20H00-21H00', 41, 41, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 22:00:00', '13/10/2016', 21, 22, '21H00-22H00', 44, 41, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 23:00:00', '13/10/2016', 22, 23, '22H00-23H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-13 00:00:00', '13/10/2016', 23, 0, '23H00-00H00', 12, 12, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 01:00:00', '14/10/2016', 0, 1, '00H00-01H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 02:00:00', '14/10/2016', 1, 2, '01H00-02H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 03:00:00', '14/10/2016', 2, 3, '02H00-03H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 04:00:00', '14/10/2016', 3, 4, '03H00-04H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 05:00:00', '14/10/2016', 4, 5, '04H00-05H00', 7, 7, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 06:00:00', '14/10/2016', 5, 6, '05H00-06H00', 23, 21, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 07:00:00', '14/10/2016', 6, 7, '06H00-07H00', 43, 40, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 08:00:00', '14/10/2016', 7, 8, '07H00-08H00', 189, 181, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 09:00:00', '14/10/2016', 8, 9, '08H00-09H00', 280, 271, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 10:00:00', '14/10/2016', 9, 10, '09H00-10H00', 140, 133, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 11:00:00', '14/10/2016', 10, 11, '10H00-11H00', 114, 104, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 12:00:00', '14/10/2016', 11, 12, '11H00-12H00', 123, 109, 14, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 13:00:00', '14/10/2016', 12, 13, '12H00-13H00', 97, 92, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 14:00:00', '14/10/2016', 13, 14, '13H00-14H00', 138, 130, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 15:00:00', '14/10/2016', 14, 15, '14H00-15H00', 158, 151, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 16:00:00', '14/10/2016', 15, 16, '15H00-16H00', 126, 120, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 17:00:00', '14/10/2016', 16, 17, '16H00-17H00', 136, 132, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 18:00:00', '14/10/2016', 17, 18, '17H00-18H00', 189, 183, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 19:00:00', '14/10/2016', 18, 19, '18H00-19H00', 149, 144, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 20:00:00', '14/10/2016', 19, 20, '19H00-20H00', 125, 122, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 21:00:00', '14/10/2016', 20, 21, '20H00-21H00', 84, 84, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 22:00:00', '14/10/2016', 21, 22, '21H00-22H00', 44, 43, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 23:00:00', '14/10/2016', 22, 23, '22H00-23H00', 25, 24, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-14 00:00:00', '14/10/2016', 23, 0, '23H00-00H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 01:00:00', '15/10/2016', 0, 1, '00H00-01H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 02:00:00', '15/10/2016', 1, 2, '01H00-02H00', 19, 19, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 03:00:00', '15/10/2016', 2, 3, '02H00-03H00', 2, 2, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 04:00:00', '15/10/2016', 3, 4, '03H00-04H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 05:00:00', '15/10/2016', 4, 5, '04H00-05H00', 6, 5, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 06:00:00', '15/10/2016', 5, 6, '05H00-06H00', 10, 9, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 07:00:00', '15/10/2016', 6, 7, '06H00-07H00', 17, 15, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 08:00:00', '15/10/2016', 7, 8, '07H00-08H00', 25, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 09:00:00', '15/10/2016', 8, 9, '08H00-09H00', 97, 92, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 10:00:00', '15/10/2016', 9, 10, '09H00-10H00', 131, 130, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 11:00:00', '15/10/2016', 10, 11, '10H00-11H00', 161, 155, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 12:00:00', '15/10/2016', 11, 12, '11H00-12H00', 149, 143, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 13:00:00', '15/10/2016', 12, 13, '12H00-13H00', 122, 118, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 14:00:00', '15/10/2016', 13, 14, '13H00-14H00', 124, 123, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 15:00:00', '15/10/2016', 14, 15, '14H00-15H00', 188, 185, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 16:00:00', '15/10/2016', 15, 16, '15H00-16H00', 172, 170, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 17:00:00', '15/10/2016', 16, 17, '16H00-17H00', 173, 172, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 18:00:00', '15/10/2016', 17, 18, '17H00-18H00', 161, 158, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 19:00:00', '15/10/2016', 18, 19, '18H00-19H00', 155, 153, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 20:00:00', '15/10/2016', 19, 20, '19H00-20H00', 170, 167, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 21:00:00', '15/10/2016', 20, 21, '20H00-21H00', 56, 55, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 22:00:00', '15/10/2016', 21, 22, '21H00-22H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 23:00:00', '15/10/2016', 22, 23, '22H00-23H00', 31, 31, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-15 00:00:00', '15/10/2016', 23, 0, '23H00-00H00', 24, 24, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 01:00:00', '16/10/2016', 0, 1, '00H00-01H00', 35, 34, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 02:00:00', '16/10/2016', 1, 2, '01H00-02H00', 25, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 03:00:00', '16/10/2016', 2, 3, '02H00-03H00', 19, 18, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 04:00:00', '16/10/2016', 3, 4, '03H00-04H00', 9, 9, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 05:00:00', '16/10/2016', 4, 5, '04H00-05H00', 6, 6, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 06:00:00', '16/10/2016', 5, 6, '05H00-06H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 07:00:00', '16/10/2016', 6, 7, '06H00-07H00', 11, 11, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 08:00:00', '16/10/2016', 7, 8, '07H00-08H00', 13, 13, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 09:00:00', '16/10/2016', 8, 9, '08H00-09H00', 44, 44, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 10:00:00', '16/10/2016', 9, 10, '09H00-10H00', 62, 61, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 11:00:00', '16/10/2016', 10, 11, '10H00-11H00', 142, 140, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 12:00:00', '16/10/2016', 11, 12, '11H00-12H00', 127, 125, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 13:00:00', '16/10/2016', 12, 13, '12H00-13H00', 140, 137, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 14:00:00', '16/10/2016', 13, 14, '13H00-14H00', 69, 68, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 15:00:00', '16/10/2016', 14, 15, '14H00-15H00', 84, 83, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 16:00:00', '16/10/2016', 15, 16, '15H00-16H00', 93, 93, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 17:00:00', '16/10/2016', 16, 17, '16H00-17H00', 87, 84, 3, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 18:00:00', '16/10/2016', 17, 18, '17H00-18H00', 121, 120, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 19:00:00', '16/10/2016', 18, 19, '18H00-19H00', 130, 129, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 20:00:00', '16/10/2016', 19, 20, '19H00-20H00', 131, 127, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 21:00:00', '16/10/2016', 20, 21, '20H00-21H00', 47, 47, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 22:00:00', '16/10/2016', 21, 22, '21H00-22H00', 22, 22, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 23:00:00', '16/10/2016', 22, 23, '22H00-23H00', 19, 18, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-16 00:00:00', '16/10/2016', 23, 0, '23H00-00H00', 5, 5, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 01:00:00', '17/10/2016', 0, 1, '00H00-01H00', 4, 4, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 02:00:00', '17/10/2016', 1, 2, '01H00-02H00', 1, 1, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 03:00:00', '17/10/2016', 2, 3, '02H00-03H00', 3, 3, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 04:00:00', '17/10/2016', 3, 4, '03H00-04H00', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 05:00:00', '17/10/2016', 4, 5, '04H00-05H00', 8, 8, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 06:00:00', '17/10/2016', 5, 6, '05H00-06H00', 20, 19, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 07:00:00', '17/10/2016', 6, 7, '06H00-07H00', 36, 35, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 08:00:00', '17/10/2016', 7, 8, '07H00-08H00', 197, 188, 9, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 09:00:00', '17/10/2016', 8, 9, '08H00-09H00', 266, 259, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 10:00:00', '17/10/2016', 9, 10, '09H00-10H00', 129, 124, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 11:00:00', '17/10/2016', 10, 11, '10H00-11H00', 110, 105, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 12:00:00', '17/10/2016', 11, 12, '11H00-12H00', 114, 106, 8, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 13:00:00', '17/10/2016', 12, 13, '12H00-13H00', 83, 81, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 14:00:00', '17/10/2016', 13, 14, '13H00-14H00', 124, 119, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 15:00:00', '17/10/2016', 14, 15, '14H00-15H00', 95, 85, 10, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 16:00:00', '17/10/2016', 15, 16, '15H00-16H00', 102, 96, 6, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 17:00:00', '17/10/2016', 16, 17, '16H00-17H00', 136, 129, 7, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 18:00:00', '17/10/2016', 17, 18, '17H00-18H00', 144, 139, 5, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 19:00:00', '17/10/2016', 18, 19, '18H00-19H00', 142, 138, 4, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 20:00:00', '17/10/2016', 19, 20, '19H00-20H00', 112, 110, 2, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 21:00:00', '17/10/2016', 20, 21, '20H00-21H00', 73, 72, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 22:00:00', '17/10/2016', 21, 22, '21H00-22H00', 26, 25, 1, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 23:00:00', '17/10/2016', 22, 23, '22H00-23H00', 17, 17, 0, NULL, NULL, NULL, NULL);
INSERT INTO comptage_automatique VALUES (1, 9, '2016-10-17 00:00:00', '17/10/2016', 23, 0, '23H00-00H00', 8, 8, 0, NULL, NULL, NULL, NULL);


--
-- TOC entry 3411 (class 0 OID 215891)
-- Dependencies: 212
-- Data for Name: comptage_dom_station_sens; Type: TABLE DATA; Schema: mobilite_transp; Owner: -
--

INSERT INTO comptage_dom_station_sens VALUES (1, 'dans le sens 1');
INSERT INTO comptage_dom_station_sens VALUES (1, 'dans le sens 2');
INSERT INTO comptage_dom_station_sens VALUES (3, 'dans les 2sens');


--
-- TOC entry 3412 (class 0 OID 215894)
-- Dependencies: 213
-- Data for Name: comptage_dom_station_type; Type: TABLE DATA; Schema: mobilite_transp; Owner: -
--

INSERT INTO comptage_dom_station_type VALUES (1, 'PL + VL');
INSERT INTO comptage_dom_station_type VALUES (2, 'vélo sur aménagement');
INSERT INTO comptage_dom_station_type VALUES (3, 'vélo hors aménagement');
INSERT INTO comptage_dom_station_type VALUES (4, 'piéton sur passage');
INSERT INTO comptage_dom_station_type VALUES (5, 'piéton hors passage');


--
-- TOC entry 3417 (class 0 OID 215968)
-- Dependencies: 219
-- Data for Name: comptage_enquete; Type: TABLE DATA; Schema: mobilite_transp; Owner: -
--

INSERT INTO comptage_enquete VALUES (1, '35120', 'Gévezé octobre 2016', NULL, '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 'oui', NULL);


--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 218
-- Name: comptage_enquete_enquete_id_seq; Type: SEQUENCE SET; Schema: mobilite_transp; Owner: -
--

SELECT pg_catalog.setval('comptage_enquete_enquete_id_seq', 1, true);


--
-- TOC entry 3414 (class 0 OID 215899)
-- Dependencies: 215
-- Data for Name: comptage_station; Type: TABLE DATA; Schema: mobilite_transp; Owner: -
--

INSERT INTO comptage_station VALUES (1, '35120', NULL, 1, 1, 'Rue de Rennes - Vers le sud-est', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 135, '01010000206C0F0000D6728AD33A863441797EA7888C995B41');
INSERT INTO comptage_station VALUES (2, '35120', NULL, 1, 2, 'Rue de Rennes - Vers le nord-ouest', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 315, '01010000206C0F0000D8D154E53F8634412DCEFD0D8E995B41');
INSERT INTO comptage_station VALUES (3, '35120', NULL, 1, 1, 'Rue de la Mézière - Vers l''est', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 65, '01010000206C0F0000C6F8AA01648534416D6589E43A9A5B41');
INSERT INTO comptage_station VALUES (4, '35120', NULL, 1, 2, 'Rue de la Mézière - Vers l''ouest', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 240, '01010000206C0F0000F9181CFE62853441555E345E3B9A5B41');
INSERT INTO comptage_station VALUES (5, '35120', NULL, 1, 1, 'RD287 - Vers le nord', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 320, '01010000206C0F00007C339DA99D8434418F58F50F5E9A5B41');
INSERT INTO comptage_station VALUES (6, '35120', NULL, 1, 2, 'RD287 - Vers le sud', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 140, '01010000206C0F0000F4DF29419B843441A44D83A65D9A5B41');
INSERT INTO comptage_station VALUES (7, '35120', NULL, 1, 1, 'Rue de Dinan - Vers le nord', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 330, '01010000206C0F0000A40E5A4C45813441C218F73FB99A5B41');
INSERT INTO comptage_station VALUES (8, '35120', NULL, 1, 2, 'Rue de Dinan - Vers le sud', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 150, '01010000206C0F000042933B2142813441D70D85D6B89A5B41');
INSERT INTO comptage_station VALUES (9, '35120', NULL, 1, 1, 'Rue de Romillé - Vers l''est', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 90, '01010000206C0F00007107080B41803441D7BF051B1F9A5B41');
INSERT INTO comptage_station VALUES (10, '35120', NULL, 1, 2, 'Rue de Romillé - Vers l''ouest', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 270, '01010000206C0F00008473B2A94080344132ACA2D91F9A5B41');
INSERT INTO comptage_station VALUES (11, '35120', NULL, 1, 1, 'Rue d''Armor - Vers le sud', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 185, '01010000206C0F0000CFF495D6AB823441D749C94526995B41');
INSERT INTO comptage_station VALUES (12, '35120', NULL, 1, 2, 'Rue d''Armor - Vers le nord', '2016-10-11 00:00:00', '2016-10-17 00:00:00', NULL, NULL, NULL, NULL, 5, '01010000206C0F000047EE2590AE823441580EBB4126995B41');


--
-- TOC entry 3425 (class 0 OID 0)
-- Dependencies: 214
-- Name: comptage_station_station_id_seq; Type: SEQUENCE SET; Schema: mobilite_transp; Owner: -
--

SELECT pg_catalog.setval('comptage_station_station_id_seq', 12, true);


-- Completed on 2017-11-20 09:27:12

 GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA mobilite_transp TO "www-data";

--
-- PostgreSQL database dump complete
--

