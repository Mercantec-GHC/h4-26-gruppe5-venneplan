using System.Text.Json.Serialization;

namespace API.Models
{
    public class Event : Common
    {
        public required string Title { get; set; }
        public required string Adress { get; set; }
        public required DateTime Date { get; set; }
        public string? Description { get; set; }
        public required int HostId { get; set; }
        public required User Host { get; set; }

        public List<EventParticipant> Participants { get; set; } = new();
    }
}
