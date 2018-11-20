package ca.uqac.gomoku.aspect;

import java.lang.reflect.Field;

import org.aspectj.lang.JoinPoint;

import ca.uqac.gomoku.core.GridEventListener;
import ca.uqac.gomoku.core.Player;
import ca.uqac.gomoku.core.model.Grid;
import ca.uqac.gomoku.core.model.Spot;
import ca.uqac.gomoku.ui.App;
import ca.uqac.gomoku.ui.Board;
import javafx.event.EventHandler;
import javafx.scene.input.MouseEvent;

import java.util.ArrayList;
import java.util.List;

public aspect AspectFinDuJeu 
{
	
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
				System.out.println("cleared");
			}
			catch(Exception e)
			{
				System.out.println(e.getClass().toString());
			}
						
		}	
		
	}
	
	pointcut game_over():execution(private void notifyGameOver(Player));

}
