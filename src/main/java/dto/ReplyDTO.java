package dto;

import java.sql.Timestamp;

public class ReplyDTO {
	private int id;
	private String writer;
	private String contents;
	private Timestamp writeDate;
	private int parentSeq;
	
	public ReplyDTO(int id, String writer, String contents, Timestamp writeDate, int parentSeq) {
		super();
		this.id = id;
		this.writer = writer;
		this.contents = contents;
		this.writeDate = writeDate;
		this.parentSeq = parentSeq;
	}
	
	public ReplyDTO(int id, String writer, String contents, int writeDate, int parentSeq) {
		super();
		this.id = id;
		this.writer = writer;
		this.contents = contents;
		this.parentSeq = parentSeq;
	}

	public int getId() {
		return id;
	}

	public String getWriter() {
		return writer;
	}

	public String getContents() {
		return contents;
	}

	public Timestamp getWriteDate() {
		return writeDate;
	}

	public int getParentSeq() {
		return parentSeq;
	}

}
