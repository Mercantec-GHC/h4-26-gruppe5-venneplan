namespace API.DTOS
{
    public class SendDto { 
        public int SenderId { get; set; } = 0; 
        public int ReceiverId { get; set; } = 0; 
        public string Content { get; set; } = ""; 
    }
}
