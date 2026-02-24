using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using API.DBContext;
using API.DTOS;
using API.Models;
using BCrypt.Net;
using API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class UsersController : Controller
    {
        private readonly AppDBContext _context;
        private readonly JwtService jwtService;
        public UsersController(AppDBContext context, JwtService jwtService)
        {
            _context = context;
            this.jwtService = jwtService;
        }

        [HttpGet("get")]
        public async Task<ActionResult<IEnumerable<GetUserDTO>>> GetUsers()
        {
            var users = await _context.Users.Select(u => new GetUserDTO
            {
                Email = u.Email,
                Name = u.Name,
                City = u.City,
                Role = u.Role,
                Age = u.Age
            })
            .ToListAsync();

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
                HashedPassword = hashedPassword,
                City = dto.City,
                Gender = dto.Gender,
                Age = dto.Age,
                Salt = dto.Salt,
                Role = dto.Role,
                Token = "",
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

            user.LastLogin = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            var token = jwtService.GenerateToken(user);

            return Ok(new {message = "Login", dto.Email, token});
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
