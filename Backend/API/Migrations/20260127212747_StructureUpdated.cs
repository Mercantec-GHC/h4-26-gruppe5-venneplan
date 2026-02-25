using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations
{
    /// <inheritdoc />
    public partial class StructureUpdated : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Friends_Users_userId",
                table: "Friends");

            migrationBuilder.RenameColumn(
                name: "userId",
                table: "Friends",
                newName: "UserId");

            migrationBuilder.RenameColumn(
                name: "friendScore",
                table: "Friends",
                newName: "FriendScore");

            migrationBuilder.RenameColumn(
                name: "friendId",
                table: "Friends",
                newName: "FriendId");

            migrationBuilder.RenameIndex(
                name: "IX_Friends_userId",
                table: "Friends",
                newName: "IX_Friends_UserId");

            migrationBuilder.AddColumn<string>(
                name: "FriendRequestStatus",
                table: "Friends",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddForeignKey(
                name: "FK_Friends_Users_UserId",
                table: "Friends",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Friends_Users_UserId",
                table: "Friends");

            migrationBuilder.DropColumn(
                name: "FriendRequestStatus",
                table: "Friends");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "Friends",
                newName: "userId");

            migrationBuilder.RenameColumn(
                name: "FriendScore",
                table: "Friends",
                newName: "friendScore");

            migrationBuilder.RenameColumn(
                name: "FriendId",
                table: "Friends",
                newName: "friendId");

            migrationBuilder.RenameIndex(
                name: "IX_Friends_UserId",
                table: "Friends",
                newName: "IX_Friends_userId");

            migrationBuilder.AddForeignKey(
                name: "FK_Friends_Users_userId",
                table: "Friends",
                column: "userId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
