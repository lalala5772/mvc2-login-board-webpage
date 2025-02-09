package dto;

import java.io.File;

public class FilesDTO {
	private int id;
	
	private String oriName;
	private String sysName;
	private int parent_seq;
	
	public FilesDTO(int id, String oriName, String sysName, int parent_seq) {
		super();
		this.id = id;
		this.oriName = oriName;
		this.sysName = sysName;
//		this.file = file;
		this.parent_seq = parent_seq;
	}

	public int getId() {
		return id;
	}

	public String getOriName() {
		return oriName;
	}

	public String getSysName() {
		return sysName;
	}

//	public File getFile() {
//		return file;
//	}

	public int getParent_seq() {
		return parent_seq;
	}

}
