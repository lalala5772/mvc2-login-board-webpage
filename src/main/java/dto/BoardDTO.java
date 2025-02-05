package dto;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class BoardDTO {
    private int seq;
    private String writer;
    private String title;
    private String contents;
    private Timestamp writeDate;
    private int viewCount;
    private String displayTime;

    public BoardDTO(int seq, String writer, String title, String contents, int viewCount) {
        super();
        this.seq = seq;
        this.writer = writer;
        this.title = title;
        this.contents = contents;
        this.viewCount = viewCount;
    }

    public BoardDTO(int seq, String writer, String title, String contents, Timestamp writeDate, int viewCount) {
        super();
        this.seq = seq;
        this.writer = writer;
        this.title = title;
        this.contents = contents;
        this.writeDate = writeDate;
        this.viewCount = viewCount;
        this.displayTime = calculateDisplayTime(writeDate);
    }

    public int getSeq() {
        return seq;
    }

    public String getWriter() {
        return writer;
    }

    public String getTitle() {
        return title;
    }

    public String getContents() {
        return contents;
    }

    public Timestamp getWriteDate() {
        return writeDate;
    }

    // viewCount는 외부에서 직접 수정하지 않도록 함
    public int getViewCount() {
        return viewCount;
    }

    // viewCount를 안전하게 증가시키는 메서드 제공
    public void incrementViewCount() {
        this.viewCount++;
    }

    private String calculateDisplayTime(Timestamp writeDate) {
        long currentTime = System.currentTimeMillis();
        long writeTime = writeDate.getTime();
        long diffMillis = currentTime - writeTime;
        
        long diffMinutes = diffMillis / (60 * 1000);
        long diffHours = diffMillis / (60 * 60 * 1000);

        if (diffMinutes < 1) {
            return "방금 전";
        } else if (diffMinutes <= 5) {
            return "5분 이내";
        } else if (diffHours < 1) {
            return "1시간 이내";
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm");
            return sdf.format(writeDate);
        }
    }

    public String getDisplayTime() {
        return displayTime;
    }
}
