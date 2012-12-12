-- initialization script

SELECT kmdata.initsources();

SELECT kmdata.importusersfromps();
SELECT COUNT(*) FROM kmdata.users; -- 1216256
SELECT COUNT(*) FROM kmdata.user_identifiers; -- 1216256

SELECT kmdata.processuserbios();
SELECT COUNT(*) FROM kmdata.narratives; -- 3980

INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Journal Article');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Abstract');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Book And Monograph');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Bulletin And Technical Report');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Chapter In Book');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Edited Book');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Potential Publication Under Review');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Unpublished Scholarly Presentation');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Review');
INSERT INTO kmdata.publication_type_refs (publication_type_descr) VALUES ('Paper In Proceeding');
SELECT kmdata.processarticles();
SELECT COUNT(*) FROM kmdata.publications; -- 214286

INSERT INTO kmdata.work_arch_types (type_description) VALUES ('media');
INSERT INTO kmdata.work_arch_types (type_description) VALUES ('audio');
INSERT INTO kmdata.work_arch_types (type_description) VALUES ('file');
INSERT INTO kmdata.work_arch_types (type_description) VALUES ('3d');
INSERT INTO kmdata.work_arch_types (type_description) VALUES ('doc');
INSERT INTO kmdata.work_arch_types (type_description) VALUES ('video');
SELECT kmdata.processksadata();
SELECT COUNT(*) FROM kmdata.work_arch_details; -- 1998

SELECT COUNT(*) FROM kmdata.locations_ksa; -- 2165
SELECT kmdata.processksaworklocations();
SELECT COUNT(*) FROM kmdata.locations; -- 353
SELECT COUNT(*) FROM kmdata.work_locations; -- 1660

