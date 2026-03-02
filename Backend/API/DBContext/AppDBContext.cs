using Microsoft.EntityFrameworkCore;

namespace API.DBContext
{
    public class AppDBContext : DbContext
    {
        public AppDBContext(DbContextOptions<AppDBContext> options)
            : base(options)
        {
        }
        public DbSet<Models.User> Users { get; set; }
        public DbSet<Models.Friend> Friends { get; set; }
        public DbSet<Models.Group> Groups { get; set; }
        public DbSet<Models.GroupMember> GroupMembers { get; set; }
        public DbSet<Models.Event> Events { get; set; }
        public DbSet<Models.EventParticipant> EventParticipants { get; set; }
    }
}
