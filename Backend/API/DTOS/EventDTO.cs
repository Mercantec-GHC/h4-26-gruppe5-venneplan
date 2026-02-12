using API.Models;

namespace API.DTOS
{
    public class EventGetDTO
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Adress { get; set; } = string.Empty;
        public DateTime Date { get; set; }
        public string? Description { get; set; }
        public int HostId { get; set; }
        public required GetUserDTO Host { get; set; }
        public int ParticipantCount { get; set; }
    }

    public class EventCreateDTO
    {
        public string Title { get; set; } = string.Empty;
        public string Adress { get; set; } = string.Empty;
        public DateTime Date { get; set; } = DateTime.Now;
        public string? Description { get; set; }
        public int HostId { get; set; }
    }

    public class EventUpdateDTO
    {
        public string Title { get; set; } = string.Empty;
        public string Adress { get; set; } = string.Empty;
        public DateTime Date { get; set; }
        public string? Description { get; set; }
        public int HostId { get; set; }
    }

    public class AddParticipantDTO
    {
        public int EventId { get; set; }
        public int UserId { get; set; }
        public bool IsGoing { get; set; }
    }
}
