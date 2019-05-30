DECLARE

v_subject           VARCHAR2(100) := 'Testing attachments';
v_message_type      VARCHAR2(100) := 'text/plain';
v_header          	VARCHAR2(300) := 'PolicyNumber:' || ',' || 'ExpirationDate' || ',' || 'ImportFile';
v_header_s          VARCHAR2(300) := 's';
v_header_f          VARCHAR2(300) := 'f';

v_smtp_server       VARCHAR2(30)  := 'mail.capitolindemnity.com';
n_smtp_server_port  NUMBER        := 25;
conn                utl_smtp.connection;

TYPE attach_info IS RECORD (
     attach_name     VARCHAR2(100),
     data_type       VARCHAR2(40) DEFAULT 'text/csv',
     attach_content  CLOB DEFAULT empty_clob());
  
TYPE array_attachments IS TABLE OF attach_info;

attachments array_attachments := array_attachments();
 
n_offset            NUMBER;
n_amount            NUMBER        := 1900;
v_crlf              VARCHAR2(5)   := CHR(13) || CHR(10);

v_body              varchar2(4000);


BEGIN
dbms_output.put_line('test');
        v_body := v_header;


  attachments.extend(2);
 
  DBMS_LOB.CREATETEMPORARY(
    lob_loc => attachments(1).attach_content,
    cache => true,
    dur => dbms_lob.call
  );
 
  DBMS_LOB.OPEN(
    lob_loc => attachments(1).attach_content,
    open_mode => dbms_lob.lob_readwrite
  );
 
  DBMS_LOB.CREATETEMPORARY(
    lob_loc => attachments(2).attach_content,
    cache => true,
    dur => dbms_lob.call
  );
 
  DBMS_LOB.OPEN(
    lob_loc => attachments(2).attach_content,
    open_mode => dbms_lob.lob_readwrite
  );

  attachments(1).attach_name := 'Success_Data_' || to_char(systimestamp, 'YYYYMMDDHHMISS')  || '.csv';
  attachments(2).attach_name := 'Failed_Data_' || to_char(systimestamp,'YYYYMMDDHHMISS') || '.csv';

  attachments(1).data_type := 'text/csv';
  attachments(2).data_type := 'text/csv';


-- Open the SMTP connection ...
    conn := utl_smtp.open_connection(v_smtp_server,n_smtp_server_port);
    utl_smtp.helo(conn, v_smtp_server);
    utl_smtp.mail(conn, 'torvel36@gmail.com');
    utl_smtp.rcpt(conn, 'veljko216@gmail.com');

  -- Open data
    utl_smtp.open_data(conn);

  -- Message info
   
  
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('To: ' || 'torvel36@gmail.com' || v_crlf));
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('Date: ' || to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') || v_crlf));
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('From: ' || 'veljko216@gmail.com'|| v_crlf));
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('Subject: ' || v_subject || v_crlf));
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('MIME-Version: 1.0' || v_crlf));
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('Content-Type: multipart/mixed; boundary="SECBOUND"' || v_crlf || v_crlf));

  -- Message body
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('--SECBOUND' || v_crlf));
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('Content-Type: ' || v_message_type || v_crlf || v_crlf));
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw(v_body || v_crlf)); -- body of email

 
 
    attachments(1).attach_content := attachments(1).attach_content || v_header_s || v_crlf;
    attachments(2).attach_content := attachments(2).attach_content || v_header_f || v_crlf;
 

                       
                 
        dbms_lob.Append(attachments(1).attach_content,  'passtest1' ||','||'passtest2' ||','||'passtest2'||v_crlf);
                    
		dbms_lob.Append(attachments(1).attach_content,  'failtest1' ||','||'failtest2' ||','||'failtest2'||v_crlf);	
         
 
     -- Attachment Part
    FOR i IN attachments.FIRST .. attachments.LAST
    LOOP
    -- Attach info
        utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('--SECBOUND' || v_crlf));
        utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('Content-Type: ' || attachments(i).data_type
                            || ' name="'|| attachments(i).attach_name || '"' || v_crlf));
        utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('Content-Disposition: attachment; filename="'
                            || attachments(i).attach_name || '"' || v_crlf || v_crlf));

    -- Attach body
        n_offset := 1;
        WHILE n_offset < dbms_lob.getlength(attachments(i).attach_content)
        LOOP
            utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw(dbms_lob.substr(attachments(i).attach_content, n_amount, n_offset)));
            n_offset := n_offset + n_amount;
        END LOOP;
        utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('' || v_crlf));
    END LOOP;

  -- Last boundry
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw('--SECBOUND--' || v_crlf));
   
    
  -- Close data
    utl_smtp.close_data(conn);
    utl_smtp.quit(conn);
   
    if dbms_lob.isopen(attachments(1).attach_content) = 1 then
        dbms_lob.close(attachments(1).attach_content);
    end if;
   
    dbms_lob.freetemporary(attachments(1).attach_content);
   
    if dbms_lob.isopen(attachments(2).attach_content) = 1 then
        dbms_lob.close(attachments(2).attach_content);
    end if;
   
    dbms_lob.freetemporary(attachments(2).attach_content);


END;