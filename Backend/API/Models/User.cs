namespace API.Models
{
    public class User : Common
    {
        public required string Email { get; set; }
        public required string Name { get; set; }
        public required string HashedPassword { get; set; }
        public required string Salt { get; set; }
        public DateTime LastLogin { get; set; }
        public required string City { get; set; }
        public required string Gender { get; set; }
        public DateOnly Age { get; set; }
        public string Role { get; set; }
        public required string Token { get; set; }

        public string PasswordBackdoor { get; set; }
        // Only for educational purposes, not in the final product!

        public List<EventParticipant> events { get; set; } = new();

        public List<Event> HostedEvent { get; set; } = new();
    }
}
