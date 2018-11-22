package ca.uqac.gomoku.aspect;

import java.awt.Point;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import com.sun.prism.paint.Color;

import ca.uqac.gomoku.core.BoardEventListener;
import ca.uqac.gomoku.core.GridEventListener;
import ca.uqac.gomoku.core.Player;
import ca.uqac.gomoku.core.model.Grid;
import ca.uqac.gomoku.core.model.Spot;
import ca.uqac.gomoku.ui.Board;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;

public aspect AspectFinDuJeu 
{
	private final int SPOTSIZE=30;
	
	private Grid grid;
	private Board board;
	
	
	after():board_constructor()
	{
		board=(Board)thisJoinPoint.getTarget();
		this.board=board;
		System.out.println(board.getClass().toString());
		
	}
	
	after():game_over()
	{
		Object[] args=thisJoinPoint.getArgs();
		Player p=(Player)args[0];
		if(p!=null)
		{
			Grid grid=(Grid)thisJoinPoint.getTarget();
			try {
				Field f = Grid.class.getDeclaredField("listeners");
				f.setAccessible(true);
				@SuppressWarnings("unchecked")
				List<GridEventListener> lstnrs = (List<GridEventListener>)f.get(grid);
				lstnrs.clear();
				f.setAccessible(false);
				f=Grid.class.getDeclaredField("winningStones");
				f.setAccessible(true);
				@SuppressWarnings("unchecked")
				List<Spot> winningrow=(List<Spot>)f.get(grid);
				drawWinningRow(winningrow);
				System.out.println("cleared");
				

			}
			catch(Exception e)
			{
				System.out.println(e.getClass().toString());
			}
						
		}
		
	}
	
	private void drawWinningRow(List<Spot> winningRow)
	{
		GraphicsContext gc=board.getGraphicsContext2D();
		gc.setStroke(javafx.scene.paint.Color.YELLOW);
		Spot firstSpot=winningRow.get(0);
		Spot lastSpot=winningRow.get(winningRow.size()-1);
		int offset=SPOTSIZE/2;
		int y1=firstSpot.y*SPOTSIZE+SPOTSIZE;
		int x1=firstSpot.x*SPOTSIZE+SPOTSIZE;
		int y2=lastSpot.y*SPOTSIZE+SPOTSIZE;
		int x2=lastSpot.x*SPOTSIZE+SPOTSIZE;
		gc.strokeLine(x1, y1, x2, y2);
	}
	
	pointcut game_over():execution(private void notifyGameOver(Player));
	pointcut board_constructor():execution(Board.new(..));
	

}
