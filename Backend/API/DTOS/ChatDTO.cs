namespace API.DTOS
{
    public class SendDto { 
        public int SenderId { get; set; } = 0; 
        public int ReceiverId { get; set; } = 0; 
        public string Content { get; set; } = ""; 
    }

    public class ChatMessageDto
    {
        public int Id { get; set; }
        public int SenderId { get; set; }
        public int ReceiverId { get; set; }
        public required string Content { get; set; }
        public DateTime SentAt { get; set; }
    }

}
