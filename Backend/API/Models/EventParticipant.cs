using System.Text.Json.Serialization;

namespace API.Models
{
    public class EventParticipant : Common
    {
        public required int EventId { get; set; }
        public required Event Event { get; set; }
        public required int UserId { get; set; }
        public required User User { get; set; }
        public required bool IsGoing { get; set; }
    }
}
