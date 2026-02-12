using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using API.DBContext;
using API.DTOS;
using API.Models;
using BCrypt.Net;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class UsersController : Controller
    {
        private readonly AppDBContext _context;
        public UsersController(AppDBContext context)
        {
            _context = context;
        }

        [HttpGet("get")]
        public async Task<ActionResult<IEnumerable<GetUserDTO>>> GetUsers()
        {
            var users = _context.Users.ToList();

            return Ok(users);
        }

        [HttpGet("get/{id}")]
        public async Task<ActionResult<GetUserDTO>> GetUser([FromRoute]int id)
        {
            var user = _context.Users.FindAsync(id);

            return Ok(user);
        }

        [HttpPost("register")]
        public async Task<ActionResult<RegisterDTO>> Register(RegisterDTO dto)
        {
            if(_context.Users.Any(u => u.Email == dto.Email))
            {
                return BadRequest("Email allerede i brug");
            }

            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(dto.HashedPassword);

            var user = new User
            {
                Email = dto.Email,
                Name = dto.Name,
                UserTag = dto.UserTag,
                HashedPassword = hashedPassword,
                City = dto.City,
                Gender = dto.Gender,
                Age = dto.Age,
                Salt = dto.Salt,
                PasswordBackdoor = dto.PasswordBackdoor
            };

            _context.Users.Add(user);
            _context.SaveChanges();

            return Ok(new {message = "Bruger oprettet!", dto.Email});
        }

        [HttpPost("login")]
        public async Task<ActionResult<LoginDTO>> Login(LoginDTO dto)
        {
            var user = _context.Users.FirstOrDefault(u => u.Email == dto.Email);
            if (user == null || !BCrypt.Net.BCrypt.Verify(dto.Password, user.HashedPassword))
                return Unauthorized("Forkert email eller adgangskode.");
            
            return Ok(new {message = "Login", dto.Email});
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound("Kunne ikke finde bruger");
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return Ok("Bruger slettet");
        }
    }

}
