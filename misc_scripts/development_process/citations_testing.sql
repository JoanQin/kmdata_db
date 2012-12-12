select * from researchinview.activity_import_log where riv_activity_name = 'Conference' ORDER BY id DESC LIMIT 100;

select * from ror.vw_Unpublished WHERE id = 426684 LIMIT 100;
SELECT * FROM kmdata.works WHERE resource_id = 5975237;
select * from kmdata.user_identifiers where user_id = 1183265; -- Unpublished, 426684

SELECT DISTINCT riv_activity_name FROM researchinview.activity_import_log ORDER BY riv_activity_name ASC; 

--These values are good for dev:
--Artwork: 5965842, 5933818, 5933815, 5923781
--Audiovisual: 5967398, 5965224, 5962519
--Book: 5968355, 5959089, 5924862, 5924848
--BookChapter: 5968363, 5967680, 5967664, 5965914
--EditedBook: 5970625, 5929132, 5920880, 5739438
--Journal: 5970803, 5970791, 5970775, 5970757
--Music: 5929693, 5929685, 5929671, 5755181
--OtherCreativeWork: 5970823, 5970815, 5968075, 5968061
--Patent: 5972239, 5972231, 5968675, 5933523
--Presentation: 5975724, 5975716, 5975702, 5975183
--ReferenceWork: 5975209, 5975201, 5972537, 5971118
--Software: 5972562, 5968994, 5967206, 5965147
--TechnicalReport: 5975235, 5971198, 5965784, 5962205
--Unpublished: 5975237, 5970337, 5968297, 5965162
--Conference: 5973041, 5973033, 5971524, 5971512

SELECT kmdata.get_work_citation_by_resource_id(5971512);

-- "Nuovo,Gerard,J; Elton,Terry,S; Nana-Sinkam,Patrick; Volinia,Stefano; Croce,Carlo,M; Schmittgen,Thomas,D. "A methodology for the combined in situ analyses of the precursor and mature forms of microRNAs and correlation with their putative targets." NATURE PROTOCOLS. Vol. 4, no. 1. (January 2009.): 107-115. "

select id from kmdata.works where resource_id = 5968363;
select * from ror.vw_BookChapter where id = 422752;

select * from kmdata.works where id = 422752;

select * from ror.vw_BookChapter where person_id = (select user_id from kmdata.user_identifiers where inst_username = 'wilkins.92');
